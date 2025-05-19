local function GetFunctionByName(object,functionName)
  if not(object) or not(readPointer(object)) then return nil end
  if (UE_CheckAddressAsObject(object)==0) then return end
  if object==0 then print("Invalid object") return end
  local funcs = UE_GetFunctionsOfObject(object,1)
  for k,v in pairs(funcs) do
      if v.name == functionName then return v end
  end
end
local function FreeFString(_pointer, _table)
  local ptr, cnt, max
  if _pointer then
    ptr = readPointer(_pointer)
    cnt = readInteger(_pointer+8)
    max = readInteger(_pointer+12)
  elseif (_table) then
    ptr = _table.ptr
    cnt = _table.cnt
    max = _table.max
  else
    error("Parameters were nil")
  end
  if not ptr or not cnt or not max then error("Inputs were nil") end
  local KismetStringLibrary = UE_GetAllObjectsOfClass('KismetStringLibrary')[1].obj
  if not KismetStringLibrary then return error('KismetStringLibrary object was not found') end
  local ReplaceInline = GetFunctionByName(KismetStringLibrary,'ReplaceInline').ufunction
  if not ReplaceInline then return error('ReplaceInline function was not found') end
  local ReplaceInline_Param = {
    {type=szPointer,size=8,value= ptr}, --StrProperty  SourceString.AllocatorInstance(0)
    {type=szDword,size=4,value= cnt}, --StrProperty  SourceString.ArrayNum(8)
    {type=szDword,size=4,value= max}, --StrProperty  SourceString.ArrayMax(C)
    {type=szPointer,size=8,value= ptr}, --StrProperty  SearchText.AllocatorInstance(10)
    {type=szDword,size=4,value= cnt}, --StrProperty  SearchText.ArrayNum(18)
    {type=szDword,size=4,value= max}, --StrProperty  SearchText.ArrayMax(1C)
    {type=szPointer,size=8,value= 0}, --StrProperty  ReplacementText.AllocatorInstance(20)
    {type=szDword,size=4,value= 0}, --StrProperty  ReplacementText.ArrayNum(28)
    {type=szDword,size=4,value= 0}, --StrProperty  ReplacementText.ArrayMax(2C)
    {type=szByte,size=1,value= 1} --ByteProperty  SearchCase(30) --IgnoreCase
   }
   UE_InvokeObjectEvent(KismetStringLibrary,ReplaceInline,ReplaceInline_Param)
end
local function ReadTextPropAsString(TextPropBaseAddress)
   if not(TextPropBaseAddress) or not(getAddressSafe(TextPropBaseAddress)) then return error('Address was nil') end
   if not(readPointer(TextPropBaseAddress)) or not(readPointer(readPointer(TextPropBaseAddress))) then return error("Not a valid TextProperty") end
   local KismetTextLibrary = UE_GetAllObjectsOfClass('KismetTextLibrary')[1].obj
   if not KismetTextLibrary then return error('KismetTextLibrary object was not found') end
   local Conv_TextToString = GetFunctionByName(KismetTextLibrary,'Conv_TextToString').ufunction
   if not Conv_TextToString then return error('Conv_TextToString function was not found') end
   local param = {
          {type=szPointer,value=readPointer(TextPropBaseAddress)},
          {type=szPointer,value=readPointer(TextPropBaseAddress+0x8)},
          {type=szQword,value=readPointer(TextPropBaseAddress+0x10)} --only dword required but meh...
   }
   local mem = allocateMemory(0x100)
   local data = UE_InvokeObjectEvent(KismetTextLibrary,Conv_TextToString,param,mem)
   local count = byteTableToDword({data[9],data[10],data[11],data[12]})
   local max = byteTableToDword({data[13],data[14],data[15],data[16]})
   local ptr = byteTableToQword(data)
   local retstr = readString(ptr,count*2+2,1)
   if ptr and ptr~=0 then
    FreeFString(nil,{ptr=ptr,cnt=count,max=max})
   end
   deAlloc(mem)
   return retstr
end
local function ReadPointedAddress(structForm, address)
  local node = structForm.tvStructureView.Selected
  local parent = node.Parent
  local offsets = {}
  while(parent) do
    --print(fu(integerToUserData(node.Parent.Data).Element[node.Index].Offset))
    table.insert(offsets,1,integerToUserData(node.Parent.Data).Element[node.Index].Offset)
    node = parent
    parent=parent.Parent
  end
  local pointer = 0
  for i=1,#offsets-1 do
      pointer = pointer==0 and readPointer(address+offsets[i]) or readPointer(pointer+offsets[i])
  end
  return getAddressSafe(pointer==0 and address+offsets[#offsets] or pointer+offsets[#offsets])
end

local function ReadPointedAddress_new(structForm, address)
  local element, tree = structForm.getSelectedStructElement()
  assert(element and tree,'Error: Could not track element or tree of selected node')
  local offsets = {}
  for k,v in ipairs(tree) do
    offsets[#offsets+1] = v.element.Offset
  end
  offsets[#offsets+1] = element.Offset
  local pointer = 0
  for i=1,#offsets-1 do
      pointer = pointer==0 and readPointer(address+offsets[i]) or readPointer(pointer+offsets[i])
  end
  return getAddressSafe(pointer==0 and address+offsets[#offsets] or pointer+offsets[#offsets])
end
local function GetFocusedColumn(structureForm)
  for i=0,structureForm.columnCount-1 do
      if (structureForm.Column[i].Focused) then return structureForm.Column[i] end
  end
end
local function GetFocusedElement(structureForm)
  local node = structureForm.tvStructureView.Selected
  if not(node) or not(node.Index) or not(node.Parent) then return end
  local data = integerToUserData(node.Parent.Data)
  --print(type(data))
  return integerToUserData(node.Parent.Data).Element[node.Index]
end
local function GetSelectedAddress(structureForm)
  --local ele = GetFocusedElement(structureForm)
  --local klm = GetFocusedColumn(structureForm)
  return ReadPointedAddress_new(structureForm,GetFocusedColumn(structureForm).Address)
end
local function InterpretName(structureForm)
  --print("NameInterpret",structureForm.ClassName)
  if not(UnrealPipe) then return error("Pipe was null") end
  local name = readQword(GetSelectedAddress(structureForm))
  print(UE_GetNameFromFName(name))
end
local function InterpretText(structureForm)
  --print("TextInterpret",structureForm.ClassName)
  if not(UnrealPipe) then return error("Pipe was null") end
  print(ReadTextPropAsString(getAddressSafe(GetSelectedAddress(structureForm))))
end
local function InterpretObject(structureForm)
  if not(UnrealPipe) then return error("Pipe was null") end
  local object = readPointer(GetSelectedAddress(structureForm))
  local data = UE_GetObjectData(object)
  assert(type(data)=='table','Error: Not a UObject')
  print('-----------------------------------------')
  for k,v in pairs(data) do
    if (k=='SubFields') then
	   print('#'..k..' = '..#v)
	elseif (k=='MapData') then
		if v.size  then
			print(k..'.size = '..v.size)
			print(k..'.alignment = '..v.alignment)
		else
			print(k..' = '..#v)
		end
	elseif (k=='Script') then
		local str = [[
%s = {
	Ptr = %.16X
	Count = %d
	Max = %d
}]]
	print(str:format(k,v.ptr, v.count, v.max))
	else
		print(k..' = '..v)
	end
  end
  print('-----------------------------------------')
end
local function CreateOrGetInputForm() --Custom Structure Form
  if DRAWSTRUCTUREFORM then return DRAWSTRUCTUREFORM end
  local form = createForm()
  form.Caption = "Re-evaluate structure"
  form.Name = "DRAWSTRUCTUREFORM"
  form.BorderStyle = bsSingle
  form.Position = poScreenCenter
  form.ClientHeight = 218
  form.ClientWidth = 714
  form.Height = 218
  form.Width = 714
  form.OnClose = function( s ) s.hide() end
  local memo = createMemo(form)
  memo.Name = "mText"
  memo.Align = alTop
  memo.BorderSpacing.Left = 2
  memo.BorderSpacing.Top = 2
  memo.BorderSpacing.Right = 2
  memo.BorderSpacing.Bottom = 2
  memo.Width = 710
  memo.Height = 159
  memo.Left = 2
  memo.Top = 2
  memo.Lines.Text = [[
--Return value must be a table of fields
--EXAMPLE1: return UE_GetObjectData(UCLASS_UOBJECT/USTRUCT_UOBJECT).SubFields
--EXAMPLE2: return UE_GetFieldsOfClass(UCLASS_NAME)

return fields 		--fields: table
  ]]
  local btnOK = createButton(form)
  btnOK.Name = "btnOK"
  btnOK.BorderSpacing.Left = 12
  btnOK.BorderSpacing.Top = 174
  btnOK.BorderSpacing.Right = 2
  btnOK.BorderSpacing.Bottom = 2
  btnOK.Width = 91
  btnOK.Height = 36
  btnOK.Left = 12
  btnOK.Top = 174
  btnOK.Caption = 'OK'
  btnOK.OnClick = function(sender) return xpcall(function() local fn = loadstring(memo.Lines.Text)() form.close() return fn end, function(err) print(err); print(debug.traceback()) end) end
  TabOrder = 1
  local btnCancel = createButton(form)
  btnCancel.BorderSpacing.Left = 108
  btnCancel.BorderSpacing.Top = 174
  btnCancel.BorderSpacing.Right = 2
  btnCancel.BorderSpacing.Bottom = 2
  btnCancel.Width = 91
  btnCancel.Height = 36
  btnCancel.Left = 108
  btnCancel.Top = 174
  btnCancel.Caption = 'Cancel'
  btnCancel.OnClick = function(sender) form.close() end
  TabOrder = 2
  DRAWSTRUCTUREFORM = form
  return DRAWSTRUCTUREFORM
end
local function GenerateStructureElements(frm, formfunc)
  --Gets the DissectOverride from GH-UEDumperForm
  local form = formfunc() --CreateOrGetInputForm()
  form.Owner = frm
  form.show()
  local function OKCall(sender)
    xpcall(function()
      local fields = loadstring(form.mText.Lines.Text)()
      if type(fields)~='table' then error('"table" expected got: '..type(fields)) return end
      if #fields==0 then error('No fields in the list') end
      local selele = frm.getSelectedStructElement()
      local structure = selele
      local padr = ReadPointedAddress_new(frm, GetFocusedColumn(frm).Address)
      if selele then
        if selele.VarType == 'vtPointer' then
          local inp = messageDialog('Pointer Found', 'Selected node is a pointer! Do you want to create a child structure(Yes) or just expand to the next offsets(No)?', mtConfirmation, mbYes, mbNo)
          if inp == mrYes then
            structure = structure.getChildStruct() and structure.getChildStruct() or createStructure("Element of "..fields[1].SpecialName)
            padr = readPointer(padr)
            selele.setChildStruct(structure)
          else
            structure = structure.parent
            structure.Name = "Element of "..fields[1].SpecialName
          end
		else
            structure = structure.parent
            structure.Name = "Element of "..fields[1].SpecialName
        end
        assert(structure, 'Error: "structure" was nil. It should have been an object of class "Structure"')
        --print(structure.Name)
        if not DissectOverride then loadstring( structDissectorEn )() end
        assert(DissectOverride, 'Error: function "DissectOverride" not found')
        local nm = structure.Name
        for i = structure.Count-2, 0, -1 do --empty the structure 
            structure.Element[i+1].destroy()
        end
        DissectOverride(structure,padr,fields)
      else
        error('Error: No Element Selected!')
      end
      --form.close()
    end, function(err)
      print(err); print(debug.traceback())
    end)
  end
  --OKCall()
  form.btnOK.OnClick = OKCall
end
local function regFormMenus(form)
  local Menus = {"GH UE: Print NameProperty","GH UE: Print TextProperty","GH UE: Print ObjectData", "GH UE: Draw Custom Structure"}
  local names = {"name1","name2"}
  local functions = {InterpretName,InterpretText}
  if not(form.ClassName == 'TfrmStructures2') then return end
  local timer=createTimer()
  timer.Interval=100
  timer.OnTimer = function (t)
	if (form.pmStructureView==nil) then return print('nil') end
	timer.destroy()
	local popup = form.pmStructureView
	if (popup.name1) then popup.name1.destroy() end
	if (popup.name2) then popup.name2.destroy() end
	for i=1,#Menus do
	  local menu = createMenuItem(popup)
	  menu.Caption = Menus[i]
	  popup.Items.insert(i-1,menu)
	  if i==1 then
		 menu.OnClick = function(sender,form) InterpretName(sender.Owner.Owner) end
		 menu.Shortcut = 'CTRL+1'
	  elseif i==2 then
		 menu.OnClick = function(sender,form) InterpretText(sender.Owner.Owner) end
		 menu.Shortcut = 'CTRL+2'
	  elseif i==3 then
		 menu.OnClick = function(sender,form) InterpretObject(sender.Owner.Owner) end
		 menu.Shortcut = 'CTRL+3'
	  elseif i==4 then
		 menu.OnClick = function(sender) GenerateStructureElements(form,CreateOrGetInputForm) end
		 menu.Shortcut = 'CTRL+4'
	  end
	end
  end
end
local frm = registerFormAddNotification(regFormMenus)


