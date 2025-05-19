--[[
	*****************************************************
	*Author: PeaceBeUponYou               				*
	*Contact: 				              				*
	*	Discord: PeaceBeUponYou#0085  					*
	*	Patreon: https://www.patreon.com/peaceCheats	*
	*Only available on:                   				*
	*   https://guidedhacking.com/        				*
	*****************************************************
	
	This file adds UE Menu in the main Menu
	--Credits:
		Special thanks to Dark Byte @ https://www.cheatengine.org/ for some of the functions to
		adjust the form.
--]]
require "lfs"
local bAllowNodesInFieldView = true --CE 7.5+
local cversion = '3.0.4'
function fu(str,num)
  if type(str)~='number' then printf('"fu" only formats numbers not %s',type(str)) return end
  if num then
  local stringx = string.gsub("('%.NUMX'):format(str)",'NUM',num)
  stringx = string.gsub(stringx,'str',str)
  local f = loadstring('return '..stringx)
  --print(stringx)
   return f()
  end
  --print(string.gsub("('%.NUMX'):format(str)",'NUM',num))
  return ('%X'):format(str)
end
registerLuaFunctionHighlight('fu')
UEScriptDecompileTypes = {
  WholeClass = 0,
  SpecificFunction = 1,
  Ubergraph = 2
}
local caption = "GH Unreal Engine"
local subMenus = {
	{caption = 'Init Unreal Engine Tool',	name = 'miUnrealEngineCollector'},
	{caption = 'Launch Data Collector',	name = 'miDataCollectorForm'},
	{caption = 'Enable Structure Dissect',	name = 'miUEStructDissect'}
}
local mm = getMainForm().Menu
local menuItem = mm.mnUnrealEngine4
if not(mm.mnUnrealEngine4) then
	menuItem = createMenuItem(mm)
	menuItem.Caption = caption
	menuItem.Name = 'mnUnrealEngine4'
	mm.Items.add(menuItem)
end
if not(menuItem) then print('somthing went wrong in creation of "GH Unreal Engine" menu') return end

--print(menuItem.Caption)
for i=1,#subMenus do
	local chk = createMenuItem(menuItem)
	chk.Caption = subMenus[i].caption
	chk.Name = subMenus[i].name
	menuItem.add(chk)
end
GHUESettings = nil
local function CreateSettingsForm()
	if UESettingsForm then return UESettingsForm end
	local function LoadDefaultSettings()
	  print('loading default settings')
	  local t = {
		General={},
		Dumping={
			ckbDMPUserDefinedEnums = true,
			ckbDMPFProp = true
		},
		StructureDissect={
			ckbSDDissectionType = 2, --Ask Everytime
			ckbSDSaveSubStructures=true,
			ckbSDAlwaysOn=false,
			ckbSDShowExpandedStructs=true,
			edtSDSubEntries=2,
			edtSDMainEntries=20,
			ckbSDShowUObjectFields=false,
			ckbSDAutofillGaps=true,
			ckbSDAddClassEnd=true
		},
		DataCollector={
			ckbDCBPParameters = false,
			ckbDCQuickScan = true,
			ckbDCShowInterfaces = true,
			ckbDCShowFields = true,
			ckbDCShowParentFields = true,
			ckbDCShowFuncs = true,
			ckbDCShowParentFuncs = true,
			ckbDCExpandStructs = true
		},
		Decompiler={
			ckbDeCmDontUbergraph = false,
			ckbDeCmDontScriptNode = false,
			ckbDeCmDontOwnerClass = false,
			ckbDeCmShowLocalProp = true,
			ckbDeCmShowInstanceProp = true,
			ckbDeCmShowDefaultProp = true,
			ckbDeCmShowPropertyType = true,
			ckbDeCmShowEnumNames = true,
			ckbDeCmShowBasicInfo = true
		}
	  }
	  return t
	end
	local function LoadCurrentSetting(frm)
	  frm = frm and frm or UESettingsForm
	  local t = {
		General = {
		},
		StructureDissect = {
		  ckbSDAlwaysOn = frm.ckbSDAlwaysOn.Checked,
		  ckbSDDissectionType = frm.ckbSDDissectionType.State,
		  ckbSDShowUObjectFields = frm.ckbSDShowUObjectFields.Checked,
		  ckbSDSaveSubStructures = frm.ckbSDSaveSubStructures.Checked,
		  ckbSDShowExpandedStructs = frm.ckbSDShowExpandedStructs.Checked,
		  edtSDMainEntries = tonumber(frm.edtSDMainEntries.Text) and tonumber(frm.edtSDMainEntries.Text) or 0,
		  edtSDSubEntries = tonumber(frm.edtSDSubEntries.Text) and tonumber(frm.edtSDSubEntries.Text) or 0,
		  ckbSDAutofillGaps = frm.ckbSDAutofillGaps.Checked,
		  ckbSDAddClassEnd = frm.ckbSDAddClassEnd.Checked
		},
		Dumping = {
		  ckbDMPFProp = frm.ckbDMPFProp.Checked,
		  ckbDMPUserDefinedEnums = frm.ckbDMPUserDefinedEnums.Checked
		},
		DataCollector = {
		  ckbDCBPParameters = frm.ckbDCBPParameters.Checked,
		  ckbDCQuickScan = frm.ckbDCQuickScan.Checked,
		  ckbDCShowInterfaces = frm.ckbDCShowInterfaces.Checked,
		  ckbDCShowFields = frm.ckbDCShowFields.Checked,
		  ckbDCShowParentFields = frm.ckbDCShowParentFields.Checked,
		  ckbDCShowFuncs = frm.ckbDCShowFuncs.Checked,
		  ckbDCShowParentFuncs = frm.ckbDCShowParentFuncs.Checked,
		  ckbDCExpandStructs = frm.ckbDCExpandStructs.Checked
		},
		Decompiler = {
		  ckbDeCmDontUbergraph = frm.ckbDeCmDontUbergraph.Checked,
		  ckbDeCmDontScriptNode = frm.ckbDeCmDontScriptNode.Checked,
		  ckbDeCmDontOwnerClass = frm.ckbDeCmDontOwnerClass.Checked,
		  ckbDeCmShowLocalProp = frm.ckbDeCmShowLocalProp.Checked,
		  ckbDeCmShowInstanceProp = frm.ckbDeCmShowInstanceProp.Checked,
		  ckbDeCmShowDefaultProp = frm.ckbDeCmShowDefaultProp.Checked,
		  ckbDeCmShowPropertyType = frm.ckbDeCmShowPropertyType.Checked,
		  ckbDeCmShowEnumNames = frm.ckbDeCmShowEnumNames.Checked,
		  ckbDeCmShowBasicInfo = frm.ckbDeCmShowBasicInfo.Checked
		}
	  }
	  return t
	end
	local function SetCurrentSetting(frm,settings)
		settings = settings and settings or GHUESettings
		frm = frm and frm or UESettingsForm
		
		local section = settings.StructureDissect
		frm.ckbSDAlwaysOn.Checked            = section.ckbSDAlwaysOn
		frm.ckbSDDissectionType.State 	   	 = section.ckbSDDissectionType
		frm.ckbSDShowUObjectFields.Checked   = section.ckbSDShowUObjectFields
		frm.ckbSDSaveSubStructures.Checked   = section.ckbSDSaveSubStructures
		frm.ckbSDShowExpandedStructs.Checked = section.ckbSDShowExpandedStructs
		frm.edtSDMainEntries.Text            = section.edtSDMainEntries
		frm.edtSDSubEntries.Text             = section.edtSDSubEntries
		frm.ckbSDAutofillGaps.Checked        = section.ckbSDAutofillGaps==nil and true or section.ckbSDAutofillGaps
		frm.ckbSDAddClassEnd.Checked         = section.ckbSDAddClassEnd==nil and true or section.ckbSDAddClassEnd
		
		section = settings.Dumping
		frm.ckbDMPFProp.Checked              = section.ckbDMPFProp
		frm.ckbDMPUserDefinedEnums.Checked   = section.ckbDMPUserDefinedEnums
		
		section = settings.DataCollector
		frm.ckbDCBPParameters.Checked		   	= section.ckbDCBPParameters
		frm.ckbDCQuickScan.Checked		   	   	= section.ckbDCQuickScan
		frm.ckbDCShowInterfaces.Checked 	   	= section.ckbDCShowInterfaces==nil and true or section.ckbDCShowInterfaces
		frm.ckbDCShowFields.Checked 	   		= section.ckbDCShowFields==nil and true or section.ckbDCShowFields
		frm.ckbDCShowParentFields.Checked 	   	= section.ckbDCShowParentFields==nil and true or section.ckbDCShowParentFields
		frm.ckbDCExpandStructs.Checked 	   		= section.ckbDCExpandStructs==nil and true or section.ckbDCExpandStructs
		frm.ckbDCShowFuncs.Checked 	   			= section.ckbDCShowFuncs==nil and true or section.ckbDCShowFuncs
		frm.ckbDCShowParentFuncs.Checked 	   	= section.ckbDCShowParentFuncs==nil and true or section.ckbDCShowParentFuncs
		
		section = settings.Decompiler
		frm.ckbDeCmDontUbergraph.Checked 	   = section.ckbDeCmDontUbergraph~=nil and section.ckbDeCmDontUbergraph or false
		frm.ckbDeCmDontScriptNode.Checked 	   = section.ckbDeCmDontScriptNode~=nil and section.ckbDeCmDontScriptNode or false
		frm.ckbDeCmDontOwnerClass.Checked 	   = section.ckbDeCmDontOwnerClass~=nil and section.ckbDeCmDontOwnerClass or false
		frm.ckbDeCmShowLocalProp.Checked 	   = section.ckbDeCmShowLocalProp==nil and true or section.ckbDeCmShowLocalProp
		frm.ckbDeCmShowInstanceProp.Checked	   = section.ckbDeCmShowInstanceProp==nil and true or section.ckbDeCmShowInstanceProp
		frm.ckbDeCmShowDefaultProp.Checked 	   = section.ckbDeCmShowDefaultProp==nil and true or section.ckbDeCmShowDefaultProp
		frm.ckbDeCmShowPropertyType.Checked    = section.ckbDeCmShowPropertyType==nil and true or section.ckbDeCmShowPropertyType
		frm.ckbDeCmShowEnumNames.Checked    = section.ckbDeCmShowEnumNames==nil and true or section.ckbDeCmShowEnumNames
		frm.ckbDeCmShowBasicInfo.Checked    = section.ckbDeCmShowBasicInfo==nil and true or section.ckbDeCmShowBasicInfo
	end
	local function saveIni(filename, data)
	  local file = io.open(filename, "w")
	  for section, sectionData in pairs(data) do
		file:write(string.format("[%s]\n", section))
		for key, value in pairs(sectionData) do
		  file:write(string.format("%s=%s\n", key, tostring(value)))
		end
		file:write("\n")
	  end
	  file:close()
	end

	local function loadIni(filename)
	  local data = {}
	  local section
	  for line in io.lines(filename) do
		local newSection = line:match("^%[(.-)%]$")
		if newSection then
		  section = newSection
		  data[section] = {}
		else
		  local key, value = line:match("^(.-)=(.-)$")
		  if key and value then
			if value == "true" or value == "false" then
			  data[section][key] = value == "true"
			elseif tonumber(value) then
			  data[section][key] = tonumber(value)
			else
			  data[section][key] = value
			end
		  end
		end
	  end
	  return data
	end
	local function GetSaveDir()
	  local dir = getAutorunPath()..'dlls\\GHUESetting\\Settings.ini'
	  local f,e = io.open(dir,'r')
	  if not f and e:find('No such file or directory') then
		lfs.mkdir(getAutorunPath()..'dlls\\GHUESetting\\')
		f,e = io.open(dir,'w')
	  end
	  assert(f,e)
	  --if not f then return nil end
	  io.close(f)
	  return dir
	end
	if not(UESettingsForm) then
	   local formPath = getCheatEngineDir()..[[\autorun\forms\frmUEDataDissectorSettings.FRM]]
	   local f,e = io.open(formPath,'r')
	   if f then io.close(f) else print(e); print('Error: Settings form not found') return end
	   UESettingsForm = createFormFromFile(formPath)
	   UESettingsForm.Name = 'frmUEDataDissectorSettings'
	   UESettingsForm.Caption = 'Settings'
	end
	local cond = not(GHUESettings) and GetSaveDir()
	--print(cond and 1 or 0)
	GHUESettings = cond and loadIni(GetSaveDir()) or LoadDefaultSettings(UESettingsForm)
	local bIsEveryMainNodePresent = GHUESettings['General'] and GHUESettings['StructureDissect'] and GHUESettings['Dumping'] and GHUESettings['DataCollector'] and GHUESettings['Decompiler']
	if not bIsEveryMainNodePresent and GetSaveDir() then 
	  GHUESettings = LoadCurrentSetting(UESettingsForm)
	  saveIni(GetSaveDir(),GHUESettings)
	end
	--print(UESettingsForm.ckbSDDissectionType.State,GHUESettings.StructureDissect.ckbSDDissectionType)
	if GHUESettings then SetCurrentSetting(UESettingsForm,GHUESettings) end
	--print(UESettingsForm.ckbSDDissectionType.State,GHUESettings.StructureDissect.ckbSDDissectionType)
	UESettingsForm.OnShow = function(sender)
	  saveIni(GetSaveDir(),GHUESettings)
	  if sender.refreshtimer then
		 sender.refreshtimer.OnTimer = function(sender)
		   local bl = false;
		   for k,v in pairs(LoadCurrentSetting(sender.Owner)) do
			 for kk,vv in pairs(v) do
			   if not(vv==GHUESettings[k][kk]) then
				 --print(vv,kk)
				 bl = true
				 break
			   end
			 end
		   end
		   sender.Owner.btnApply.Enabled = bl
		 end
		 --print('opening')
		 UESettingsForm.refreshtimer.Enabled = true
	  end
	end
	UESettingsForm.OnClose = function(sender)
	  --print('closing')
	  UESettingsForm.refreshtimer.Enabled = false;
	  return caHide
	end
	UESettingsForm.lbMainControl.OnSelectionChange = function(sender, user, i )
	  for i=0,sender.Items.Count-1 do
		if (sender.Selected[i]) then
		   sender.Owner.tbControlMain.TabIndex = i
		   --print(sender.Items[i])
		end
	  end
	end
	UESettingsForm.btnResetAll.OnClick = function(sender)
	  SetCurrentSetting(sender.Owner,LoadDefaultSettings())
	end
	UESettingsForm.btnOk.OnClick = function(sender)
	  sender.Owner.btnApply.OnClick(sender.Owner.btnApply)
	  sender.Owner.Close()
	end
	UESettingsForm.btnApply.OnClick = function(sender)
	  saveIni(GetSaveDir(), LoadCurrentSetting(sender.Owner))
	  GHUESettings = LoadCurrentSetting(sender.Owner)
	end
	UESettingsForm.btnCancel.OnClick = function(sender)
	  SetCurrentSetting(sender.Owner, GHUESettings)
	  sender.Owner.Close()
	end
	UESettingsForm.ckbSDAlwaysOn.OnChange = function(sender)
	    sender.Owner.ckbSDDissectionType.AllowGrayed = not(sender.Checked)
		sender.Owner.ckbSDDissectionType.State = cbChecked
		if (sender.Checked) then
			menuItem.miUEStructDissect.OnClick(menuItem.miUEStructDissect)
			if not(sender.Checked) then menuItem.miUEStructDissect.OnClick(menuItem.miUEStructDissect) end
		end
	end
	UESettingsForm.ckbDCShowFields.OnClick = function(sender)
		sender.Owner.ckbDCShowParentFields.Enabled = sender.Checked
	end
	UESettingsForm.ckbDCShowFuncs.OnClick = function(sender)
		sender.Owner.ckbDCShowParentFuncs.Enabled = sender.Checked
	end
	UESettingsForm.ckbSDDissectionType.AllowGrayed = not(UESettingsForm.ckbSDAlwaysOn.Checked)
	UESettingsForm.ckbDCShowParentFields.Enabled = UESettingsForm.ckbDCShowFields.Checked
	UESettingsForm.ckbDCShowParentFuncs.Enabled = UESettingsForm.ckbDCShowFuncs.Checked
	UESettingsForm.authProfilePic.OnClick = function() shellExecute('https://guidedhacking.com/members/peacebeuponyou.261747/#resources') end
	UESettingsForm.authProfilePic.OnDblClick = function()shellExecute('https://www.patreon.com/peaceCheats') end
	UESettingsForm.scrProfilePic.OnClick = function() shellExecute('https://guidedhacking.com/register/?referralcode=r55Am') end
	return UESettingsForm
end
local function ReplaceInternalName(subfields, nm, bNodot)
	local snm = bNodot and nm or nm..'%.'
	for k,v in pairs(subfields) do
	  v.name = v.name:gsub('None.','')
	  v.name = v.name:gsub(snm,'')
	  if v.class == 'StructProperty' then
		ReplaceInternalName(v.SubFields,nm)
	  end
	end
end
OpenedProcessID=0
miActivateUnrealEngine = function(sender)
	if not(sender) then sender = menuItem.miUnrealEngineCollector end
	if not(sender.Checked) or not(UnrealPipe) or not(UnrealPipe.Connected) or not(getAddressSafe('UnrealDataCollector64.dll')) or not(readPointer('UnrealDataCollector64.dll')) then
		if (UnrealPipe) then UnrealPipe.destroy() UnrealPipe=nil end
		getLuaEngine().mOutput.clear()
		--UnrealScanner()
		local time = os.time()
		if (LaunchUEDataCollector()~=1) then showMessage("Failure to launch Unreal Data Collector") print(debug.traceback()) return end
		printf('Time taken to launch data collector: %d seconds',os.time()-time)
		UnrealScanner()
		InitUE()
		sender.Checked = true
		OpenedProcessID = getOpenedProcessID()
		local frm = CreateSettingsForm()
		if frm and frm.ckbSDAlwaysOn.Checked then
			if not(menuItem.miUEStructDissect.Checked) then
				menuItem.miUEStructDissect.OnClick(menuItem.miUEStructDissect)
			end
		end
	elseif (sender.Checked) then
	    if isKeyPressed(VK_CONTROL) then 
			UE_EjectDllAndFree()
			print('dll ejected')
		else
			UnrealPipe.destroy();
		end
		UnrealPipe = nil
		
		unregisterSymbol('GEngine')
		unregisterSymbol('GObjects')
		unregisterSymbol('FUNames')
		unregisterSymbol('Actor::ProcessEvent')
		unregisterSymbol('Object::ProcessEvent')
		sender.Checked = false
		if (menuItem.miUEStructDissect.Checked) then
			menuItem.miUEStructDissect.OnClick(menuItem.miUEStructDissect)
		end
	end
end
menuItem.OnClick = function()
	OpenedProcessID = OpenedProcessID==0 and getOpenedProcessID() or OpenedProcessID
	menuItem.miUnrealEngineCollector.Checked = UnrealPipe~=nil and UnrealPipe.Connected and OpenedProcessID==getOpenedProcessID()
	local frm = CreateSettingsForm()
	bAlreadyChecked = bAlreadyChecked~=nil and bAlreadyChecked or false
	if frm and frm.ckbSDAlwaysOn.Checked and menuItem.miUnrealEngineCollector.Checked then
		if not(menuItem.miUEStructDissect.Checked) and not(bAlreadyChecked) then
			bAlreadyChecked = true
			menuItem.miUEStructDissect.OnClick(menuItem.miUEStructDissect)
		end
	end
end
menuItem.miUnrealEngineCollector.OnClick = miActivateUnrealEngine
structDissectorEn = function()
  local ueToCETypes = {
    ['BoolProperty']=vtByte,
    ['ByteProperty']=vtByte,
    ['Int8Property']=vtByte,
    ['Int16Property']=vtWord,
    ['IntProperty']=vtDword,
    ['Int64Property']=vtQword,
    ['UInt16Property']=vtWord,
    ['UInt32Property']=vtDword,
    ['UInt64Property']=vtQword,
    ['FloatProperty']=vtSingle,
    ['DoubleProperty']=vtDouble,

    --['StructProperty']=vtDword,
    --['EnumProperty']=vtDword,
    --['NameProperty']=vtQword,
  ---[[
    --['WeakObjectProperty']=vtQword, --size=0x08 ; int ObjectIndex, int ObjectSerialNumber
    --['LazyObjectProperty']=vtQword, --size=0x1C ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {int A,int B,int C,int D});
    --['SoftObjectProperty']=vtQword, --size=0x24 ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {FName AssetPathName, FString SubPathString});
    --['SoftClassProperty']=vtQword, --size=0x24 ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {FName AssetPathName, FString SubPathString});
    --['IntefaceProperty']=vtPointer --size=0x10 ; UObject*	ObjectPointer,void* InterfacePointer;
    --['StrProperty']=vtPointer --size=0x10 ; void*	AllocatorInstance, int ArrayNum, int ArrayMax;
    --['SetProperty'] is probably same as MapProperty
    --['DelegateProperty'] = vtPointer --size=0x10 ; WeakObjectProperty Object, FName FunctionName;
    --['MulticastSparseDelegateProperty'] = vtByte --size=0x1 ; BOOL bIsBound;
    --['MulticastInlineDelegateProperty'] = vtPointer --size=0x10 ; WeakObjectProperty Object, FName FunctionName; (it is used in ue 4.27)
    --['TextProperty'] = vtPointer --size=0xC ; ITextData(pointer) TextData.Object, FReferenceControllerBase(pointer) TextData.SharedReferenceCount.ReferenceController, int Flags;

    --vtPointer = ObjectProperty,ClassProperty
    }
  local OuterTypes = {}
    OuterTypes.None = 1
    OuterTypes.Struct = 2
    OuterTypes.Array = 3
    OuterTypes.Map = 4
    OuterTypes.Set = 5
  local enumPropSizes = {}
    enumPropSizes[1] = vtByte
    enumPropSizes[2] = vtWord
    enumPropSizes[3] = vtWord
    enumPropSizes[4] = vtDword
    enumPropSizes[5] = vtDword
    enumPropSizes[6] = vtDword
    enumPropSizes[7] = vtDword
    enumPropSizes[8] = vtQword
  local propertyTypes = {}
    propertyTypes.Unknown = 0
    propertyTypes.BoolProperty = 1
    propertyTypes.ObjectProperty = 2
    propertyTypes.StructProperty = 3
    propertyTypes.EnumProperty = 4
    propertyTypes.ArrayProperty = 5
    propertyTypes.MapProperty = 6
    propertyTypes.ClassProperty = 7
    propertyTypes.SetProperty = 8
    propertyTypes.DelegateProperty = 9
    propertyTypes.ScriptStruct = 8
    propertyTypes.Class = 9
    --Depreciated:
    propertyTypes.IntefaceProperty = 10
    propertyTypes.StrProperty = 11
    propertyTypes.TextProperty = 12
    propertyTypes.MulticastDelegateProperty = 14
    propertyTypes.MulticastSparseDelegateProperty = 15
    propertyTypes.WeakObjectProperty = 16
    propertyTypes.LazyObjectProperty = 17
    propertyTypes.SoftObjectProperty = 18

  local function GetObjectBaseOfAddress(address)
    local kls,adr = nil,nil
	if not UnrealPipe or not UnrealPipe.Connected then return nil end
    local object = UE_CheckAddressAsObject(address)
    if object and object~=0 then
	  local data = UE_GetObjectData(object)
	  return data.ClassName,data.UObject
    end
    return nil--kls,adr
  end

  local function sizeToVarType(size)
    if(size<=0)then return 0 end
    local t = {}
	  t[1]=vtByte
	  t[2]=vtWord
	  t[4]=vtDword
	  t[8]=vtPointer
    for i=1,#t do
	   if size==i then return t[i] end
    end
    return vtPointer
  end
  local function enumSizeToVarType(size)
    if(size<=0)then return 0 end
    local t = {}
	  t[1]=vtByte
	  t[2]=vtWord
	  t[4]=vtDword
	  t[8]=vtQointer
    for i=1,#t do
	   if size==i then return t[i] end
    end
    return vtQointer
  end

  local function GetCEType(klass)
	  if (ueToCETypes[klass]) then return ueToCETypes[klass]
	  else return vtPointer
	  end
  end
  local FIELD_INCLUDING = (UESettingsForm and UESettingsForm.ckbSDDissectionType.State~=2) and UESettingsForm.ckbSDDissectionType.State or (messageDialog("Dissector Selection: ","Should include fields of parent classes?",mtInformation,mbNo,mbYes)==mrYes and 1 or 0)
  local MAX_SUBFIELDS = (UESettingsForm and tonumber(UESettingsForm.edtSDMainEntries.Text)) and tonumber(UESettingsForm.edtSDMainEntries.Text) or 20
  local MAX_SUBFIELDS_INTERNAL = (UESettingsForm and tonumber(UESettingsForm.edtSDSubEntries.Text)) and tonumber(UESettingsForm.edtSDSubEntries.Text) or 2

  local function GetIncludeParent()
	  if (UESettingsForm and UESettingsForm.ckbSDDissectionType.State==2) then
		  return FIELD_INCLUDING
	  else
	     return UESettingsForm and UESettingsForm.ckbSDDissectionType.State or FIELD_INCLUDING
	  end
  end
  local function GetAllowedMaxSubFields()
	  if (UESettingsForm and tonumber(UESettingsForm.edtSDMainEntries.Text)) then
		  return tonumber(UESettingsForm.edtSDMainEntries.Text)
	  else
	     return MAX_SUBFIELDS
	  end
  end
  local function GetAllowedMaxSubFieldsInternal()
	  if (UESettingsForm and tonumber(UESettingsForm.edtSDSubEntries.Text)) then
		  return tonumber(UESettingsForm.edtSDSubEntries.Text)
	  else
	     return MAX_SUBFIELDS_INTERNAL
	  end
  end
  local function bAddMissingField()
    return UESettingsForm and UESettingsForm.ckbSDAutofillGaps and UESettingsForm.ckbSDAutofillGaps.Checked
  end
  local function bShowClassEnd()
    return UESettingsForm and UESettingsForm.ckbSDAddClassEnd and UESettingsForm.ckbSDAddClassEnd.Checked
  end
  function DissectOverride(structure,baseaddress,fields)
    local time = os.time()
	if not UnrealPipe or not UnrealPipe.Connected then return nil end
    local bAllowFill = true
    if not fields then
	    if (structure.Name:match('Autocreated from')=='Autocreated from') then return false end
	    if (not(UnrealPipe) or UnrealPipe.connected==false) then print('Error: UnrealPipe is not connected') return false end
	    local kls,adr=GetObjectBaseOfAddress(baseaddress)
	    if adr~=baseaddress then
	      return false
	    end --shit what happened???

	    local data = UE_GetObjectData(baseaddress)
	    print('\n------------------------ClassName: "'..data.ClassName..'"; Size: 0x'..("%X"):format(data.ClassSize)..' -------------------------------')
    else
	    --bAllowFill = false
    end
    fields = fields or UE_GetFieldsOfObject(baseaddress,GetIncludeParent())
    if not(fields) then return false end
    local function FieldsSorter(fields)
      for k,v in ipairs(fields) do
	    if v.class == 'StructProperty' then FieldsSorter(v.SubFields) end
      end
      table.sort(fields, function(a, b)
	    if (a.offset == b.offset) then
	       return a.FieldMask < b.FieldMask
	    end
	    return a.offset < b.offset
      end)
    end
    FieldsSorter(fields)
    structure = structure and structure or createStructure("")
    otherstructure = {}
    structure.beginUpdate()
    local function nameConcat(preConcat,name,postConcat)
		      --print(name)
	    name = name:gsub('_%d*_%x*','')
	    preConcat = preConcat and preConcat or ''
	    postConcat = postConcat and postConcat or ''
	    return preConcat..name..postConcat
    end
    local MAX_ALLOWED_SUBFIELDS = GetAllowedMaxSubFields()
    local MAX_ALLOWED_SUBFIELDS_INTERNAL = GetAllowedMaxSubFieldsInternal()
    function addStructElement(structure,
				    v,
				    Address,
				    mainOuterType, --OuterTypes
				    preConcat, --name to concate previous to current name (used by nameConcat function)
				    postConcat,--name to concate after the current name (used by nameConcat function)
				    strTable,--if outer type is an array or map, it is a table of {stringToFind, stringToReplace}
				    addOffset --next Offset to start (if array or map)
				    )
		    addOffset = addOffset and addOffset or 0
		    local function MapSetDrawExtra()
			    local mainName = nameConcat(preConcat,v.name,postConcat)
			    local mainOffset = v.offset+addOffset
			    local mapStruct = {
			      {name='Elements.AllocationFlags.AllocatorInstance.InlineData[0]',offset=0x10,size=4},
			      {name='Elements.AllocationFlags.AllocatorInstance.InlineData[1]',offset=0x14,size=4},
			      {name='Elements.AllocationFlags.AllocatorInstance.InlineData[2]',offset=0x18,size=4},
			      {name='Elements.AllocationFlags.AllocatorInstance.InlineData[3]',offset=0x1C,size=4},
			      {name='Elements.AllocationFlags.AllocatorInstance.SecondaryData.Data',offset=0x20,size=8},
			      {name='Elements.AllocationFlags.NumBits',offset=0x28,size=4},
			      {name='Elements.AllocationFlags.MaxBits',offset=0x2C,size=4},
			      {name='Elements.FirstFreeIndex',offset=0x30,size=4},
			      {name='Elements.NumFreeIndices',offset=0x34,size=4},
			      {name='Hash.InlineData[0]',offset=0x38,size=4},
			      {name='-',offset=0x3C,size=4},
			      {name='Hash.SecondaryData.Data',offset=0x40,size=8},
			      {name='HashSize',offset=0x48,size=4}
			    }
			    for kk,vv in ipairs(mapStruct) do
			      local newElement = structure.addElement()
			      newElement.Name = mainName..'['..vv.name..']'
			      newElement.Offset = mainOffset+vv.offset
			      newElement.Vartype = sizeToVarType(vv.size)
			    end
		    end
	      local function AddWeakObject()
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectIndex",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectSerialNumber",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+4+addOffset
	      end
	      local function AddDelegate(structr,precat,offset)
		    precat = precat and precat or ''
		    preConcat = preConcat and preConcat or ''
		    local element = structr.addElement()
		    element.Name = nameConcat(precat..preConcat,v.name..".ObjectIndex",postConcat)
		    element.Vartype = vtDword
		    element.Offset = offset
		    element = structr.addElement()
		    element.Name = nameConcat(precat..preConcat,v.name..".ObjectSerialNumber",postConcat)
		    element.Vartype = vtDword
		    element.Offset = offset+4
		    element = structr.addElement()
		    element.Name = nameConcat(precat..preConcat,v.name..".FunctionName",postConcat)
		    element.Vartype = vtQword
		    element.Offset = offset+8
	      end
	      local function AddSoftObjectPtr()
		    AddWeakObject()
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".TagAtLastTest",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x8
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectID.AssetPathName",postConcat)
		    element.Vartype = vtQword
		    element.Offset = v.offset+addOffset+0x10 --aligned
		    element = structure.addElement()
		    local mainName = nameConcat(preConcat,v.name..".ObjectID.SubPathString",postConcat)
		    element.Offset = v.offset+addOffset+0x18
		    element.Vartype = vtPointer
		    element.Name = mainName..'[AllocatorInstance]'
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayNum]'
		    newElement.Offset = element.Offset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayMax]'
		    newElement.Offset = element.Offset+12
		    newElement.Vartype = vtDword
		    element.ChildStruct=createStructure("")
		    element.setChildStructStart(0)
		    --Now just add a unicodestring element
		    element = element.ChildStruct.addElement()
		    element.Name = "Data"
		    element.Vartype = vtUnicodeString
		    element.Bytesize = 1000
	      end
	    if (v.PropertyType == propertyTypes.BoolProperty) then
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..'['..v.FieldMask..']',postConcat)
		    element.Vartype = GetCEType(v.class)
		    element.Offset = v.offset+addOffset

	    elseif (v.PropertyType == propertyTypes.ObjectProperty) then
		    local element = structure.addElement()
		    --element.Name = nameConcat(preConcat,(mainOuterType==OuterTypes.None and v.SpecialName or v.name),postConcat)
		    element.Name = nameConcat(preConcat,(v.name),postConcat)
		    element.Vartype = GetCEType(v.class)
		    element.Offset = v.offset+addOffset
		    element.setChildStructStart(0)

	    elseif (v.PropertyType == propertyTypes.StructProperty) then
		    if (v.class == 'ScriptStruct') then --a "propertyTypes.StructProperty" can be a UScriptStruct or UStructProperty
		    else
			    if #v.SubFields > 0 then
				    for kk,vv in pairs(v.SubFields) do
					    addStructElement(structure,vv,Address,OuterTypes.Struct,preConcat,postConcat,strTable,addOffset)--,v.SpecialName..'.')
				    end
			    else
				    local element = structure.addElement()
				    element.Name = nameConcat(preConcat,v.name,postConcat)..'(struct '..v.SpecialName..')'
				    element.Vartype = vtDword
				    element.Offset = v.offset+addOffset
			    end
		    end

	    elseif (v.PropertyType == propertyTypes.EnumProperty) then
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name,postConcat)
		    element.Vartype = enumPropSizes[v.InnerSize] --GetCEType(v.class)
		    element.Vartype = element.Vartype and element.Vartype or vtDword --if nil
		    element.Offset = v.offset+addOffset

	    elseif (v.PropertyType == propertyTypes.ArrayProperty) then
		    printf("\tArray\t%s: 0x%X", v.name, v.offset)
		    local element = structure.addElement()
		    local mainName = nameConcat(preConcat,v.name,postConcat)
		    local mainOffset = v.offset+addOffset
		    element.Name = mainName..'[AllocatorInstance]'
		    element.Offset = mainOffset
		    element.Vartype = vtPointer
		    element.ChildStruct=createStructure("")
		    element.setChildStructStart(0)
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayNum]'
		    newElement.Offset = mainOffset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayMax]'
		    newElement.Offset = mainOffset+12
		    newElement.Vartype = vtDword
		    local count = readInteger(Address+mainOffset+0x8)
		    if count > 0 then
			    print('\t\tItems: '..count, 'Allowed: '..MAX_ALLOWED_SUBFIELDS)
			    count = count <= MAX_ALLOWED_SUBFIELDS and count or MAX_ALLOWED_SUBFIELDS
			    local premax = MAX_ALLOWED_SUBFIELDS
			    MAX_ALLOWED_SUBFIELDS = MAX_ALLOWED_SUBFIELDS_INTERNAL
			    if v.SubFields[1].class == 'StructProperty' then
				    ReplaceInternalName(v.SubFields[1].SubFields, v.name)
			    end
			    local objName = v.class:gsub('Property','')
			    local kls = v.SubFields[1].class:gsub('Property','')
			    local spn = v.SubFields[1].SpecialName
			    local inName = spn=="" and kls or kls..'('..spn..')'
			    objName = '('..inName..')'
			    v.SubFields[1].name = ""
			    for i=0,count-1 do
				    v.name = v.name:gsub('_%d*_%x*','')
				    local preConcat = string.format('[%d]%s',i,objName)
				    addStructElement(element.ChildStruct,v.SubFields[1],readPointer(Address+mainOffset),OuterTypes.Array,preConcat,"",nil,i*v.InnerSize)--,v.SpecialName..'.')
			    end
			    otherstructure[#otherstructure+1] = {structure = element.ChildStruct, address = readPointer(Address+mainOffset), size = count*v.InnerSize}
			    MAX_ALLOWED_SUBFIELDS = premax
		    else
			    element.ChildStruct.destroy(); element.ChildStruct = nil
		    end
	    elseif (v.PropertyType == propertyTypes.MapProperty) then
	       --print(fu(Address))
		    printf("\tMap\t%s: 0x%X", v.name, v.offset)
		    local element = structure.addElement()
		    local mainName = nameConcat(preConcat,v.name,postConcat)
		    local mainOffset = v.offset+addOffset
		    element.Name = mainName..'[Elements.Data.AllocatorInstance]'
		    element.Offset = mainOffset
		    element.Vartype = vtPointer
		    element.ChildStruct=createStructure("")
		    element.setChildStructStart(0)
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[Elements.Data.ArrayNum]'
		    newElement.Offset = mainOffset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[Elements.Data.ArrayMax]'
		    newElement.Offset = mainOffset+12
		    newElement.Vartype = vtDword
		    local fld = v.SubFields[1]
		    fld.name = fld.SpecialName=="" and fld.class:gsub('Property','') or fld.SpecialName
		    fld = v.SubFields[2]
		    fld.name = fld.SpecialName=="" and fld.class:gsub('Property','') or fld.SpecialName
		    local count = readInteger(Address+mainOffset+0x8)
		    if count > 0 then
			    print('\t\tItems: '..count, 'Allowed: '..MAX_ALLOWED_SUBFIELDS)
			    count = count <= MAX_ALLOWED_SUBFIELDS and count or MAX_ALLOWED_SUBFIELDS
			    local premax = MAX_ALLOWED_SUBFIELDS
			    MAX_ALLOWED_SUBFIELDS = MAX_ALLOWED_SUBFIELDS_INTERNAL
			    local kls = v.SubFields[1].class:gsub('Property','')
			    local spn = v.SubFields[1].SpecialName
			    local inName = spn=="" and kls or kls..'('..spn..')'
			    inName = '('..inName..')'
			    kls = v.SubFields[2].class:gsub('Property','')
			    spn = v.SubFields[2].SpecialName
			    local inName2 = spn=="" and kls or kls..'('..spn..')'
			    inName2 = '('..inName2..')'
			    v.SubFields[2].name = ""
			    v.SubFields[1].name = ""
			    if v.SubFields[1].class == 'StructProperty' then
				    ReplaceInternalName(v.SubFields[1].SubFields, v.name, true)
			    end
			    if v.SubFields[2].class == 'StructProperty' then
				    ReplaceInternalName(v.SubFields[2].SubFields, v.name, true)
			    end
			    for i=0,count-1 do
				    v.name = v.name:gsub('_%d*_%x*','')
				    local preConcat = string.format('[%d]%sKey',i,inName)
				    addStructElement(element.ChildStruct,v.SubFields[1],readPointer(Address+mainOffset),OuterTypes.Map,preConcat,"",nil,i*v.MapData.size)--,v.SpecialName..'.')
				    preConcat = string.format('[%d]%sValue',i,inName2)
				    addStructElement(element.ChildStruct,v.SubFields[2],readPointer(Address+mainOffset),OuterTypes.Map,preConcat,"",nil,i*v.MapData.size)
			    end
			    otherstructure[#otherstructure+1] = {structure = element.ChildStruct, address = readPointer(Address+mainOffset), size = count*v.MapData.size}
			    MAX_ALLOWED_SUBFIELDS = premax
		    else
			    element.ChildStruct.destroy(); element.ChildStruct = nil
		    end
		    MapSetDrawExtra()
	    elseif (v.PropertyType == propertyTypes.SetProperty) or (v.class == 'SetProperty') then
		    printf("\tSet\t%s: 0x%X", v.name, v.offset)
		    local element = structure.addElement()
		    local mainName = nameConcat(preConcat,v.name,postConcat)
		    local mainOffset = v.offset+addOffset
		    element.Name = mainName..'[Elements.Data.AllocatorInstance]'
		    element.Offset = mainOffset
		    element.Vartype = vtPointer
		    element.ChildStruct=createStructure("")
		    element.setChildStructStart(0)
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[Elements.Data.ArrayNum]'
		    newElement.Offset = mainOffset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[Elements.Data.ArrayMax]'
		    newElement.Offset = mainOffset+12
		    newElement.Vartype = vtDword
		    --addStructElement(structure,v.SubFields[1],OuterTypes.Struct)
		    local fld = v.SubFields[1]
		    fld.name = fld.SpecialName=="" and fld.class:gsub('Property','') or fld.SpecialName
		    local count = readInteger(Address+mainOffset+0x8)
		    if count > 0 then
			    print('\t\tItems: '..count, 'Allowed: '..MAX_ALLOWED_SUBFIELDS)
			    count = count <= MAX_ALLOWED_SUBFIELDS and count or MAX_ALLOWED_SUBFIELDS
			    local premax = MAX_ALLOWED_SUBFIELDS
			    MAX_ALLOWED_SUBFIELDS = MAX_ALLOWED_SUBFIELDS_INTERNAL
			    if v.SubFields[1].class == 'StructProperty' then
				    ReplaceInternalName(v.SubFields[1].SubFields, v.name)
			    end
			    local objName = v.class:gsub('Property','')
			    local kls = v.SubFields[1].class:gsub('Property','')
			    local spn = v.SubFields[1].SpecialName
			    local inName = spn=="" and kls or kls..'('..spn..')'
			    objName = '('..inName..')'
			    v.SubFields[1].name = ""
			    for i=0,count-1 do
				    v.name = v.name:gsub('_%d*_%x*','')
				    local preConcat = string.format('[%d]%s',i,objName)
				    addStructElement(element.ChildStruct, v.SubFields[1], readPointer(Address+mainOffset), OuterTypes.Set, preConcat, "", nil, i*v.MapData.size)--,v.SpecialName..'.')
			    end
			    MAX_ALLOWED_SUBFIELDS = premax
		    else
			    element.ChildStruct.destroy(); element.ChildStruct = nil
		    end
		    otherstructure[#otherstructure+1] = {structure = element.ChildStruct, address = readPointer(Address+mainOffset), size = count*v.MapData.size}
		    MapSetDrawExtra()
	    elseif (v.PropertyType == propertyTypes.ClassProperty) then
		    if (v.class == 'Class') then --a "propertyTypes.ClassProperty" can be a UClass or UClassProperty
		      local element = structure.addElement()
		      element.Name = nameConcat(preConcat,v.name,postConcat)
		      element.Vartype = vtPointer
		      element.Offset = v.offset+addOffset
		    elseif(v.class == 'SoftClassProperty') then --size=0x1C ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {FName AssetPathName, FString SubPathString});
		      AddSoftObjectPtr()
		    else--if(v.class == 'ClassProperty')
		      local element = structure.addElement()
		      element.Name = nameConcat(preConcat,v.name..'('..v.SpecialName..')',postConcat)
		      element.Vartype = vtPointer
		      element.Offset = v.offset+addOffset
		    end
	    elseif (v.class == 'StrProperty') then
		    --similar to array
		    local element = structure.addElement()
		    local mainName = nameConcat(preConcat,v.name,postConcat)
		    local mainOffset = v.offset+addOffset --+addOffset
		    element.Name = mainName..'[AllocatorInstance]'
		    element.Offset = mainOffset
		    element.Vartype = vtPointer
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayNum]'
		    newElement.Offset = mainOffset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayMax]'
		    newElement.Offset = mainOffset+12
		    newElement.Vartype = vtDword
		    element.ChildStruct=createStructure("")
		    element.setChildStructStart(0)
		    --Now just add a unicodestring element
		    element = element.ChildStruct.addElement()
		    element.Name = "Data"
		    element.Vartype = vtUnicodeString
		    element.Bytesize = 1000

	    elseif (v.class == 'NameProperty') then
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name,postConcat)
		    element.Vartype = vtQword
		    element.Offset = v.offset+addOffset
	    elseif (v.class == 'TextProperty') then
		    --size=0xC ; ITextData(pointer) TextData.Object, FReferenceControllerBase(pointer) TextData.SharedReferenceCount.ReferenceController, int Flags;
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".TextData.Object",postConcat)
		    element.Vartype = vtPointer
		    element.Offset = v.offset+addOffset
		    local ptr = readPointer(Address+element.Offset)
		    --print('Ptr: ',fu(ptr))
		    local innerOffset = readPointer(readPointer(ptr+0x28)) and 0x28 or 0x88
		    innerOffset = (innerOffset==0x88 and readPointer(readPointer(ptr+0x88))) and 0x88 or 0x28 --if 0x88 is valid pointer then choose 0x88 else 0x28
		    --element = structure.addElement()
		    local chldStr = createStructure("")--element.ChildStruct
		    local inelement = chldStr.addElement() --inner Child
		    inelement.Name = "DisplayString[AllocatorInstance]"
		    inelement.Vartype = vtPointer
		    inelement.Offset = innerOffset  --0x88
		    inelement.ChildStruct=createStructure("")
		    inelement.setChildStructStart(0)
		    inelement = inelement.ChildStruct.addElement()
		    inelement.Name = "Data"
		    inelement.Vartype = vtUnicodeString
		    inelement.Bytesize = 1000

		    inelement = chldStr.addElement()
		    inelement.Name = "DisplayString[ArrayNum]"
		    inelement.Vartype = vtDword
		    inelement.Offset = innerOffset+8
		    inelement = chldStr.addElement()
		    inelement.Name = "DisplayString[ArrayMax]"
		    inelement.Vartype = vtDword
		    inelement.Offset = innerOffset+0xC
		    element.ChildStruct=chldStr--createStructure("")
		    element.setChildStructStart(0)

		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".TextData.SharedReferenceCount.ReferenceController",postConcat)
		    element.Vartype = vtPointer
		    element.Offset = v.offset+addOffset+8
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".Flags",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x10
	    elseif (v.class == 'WeakObjectProperty') then
		    --size=0x08 ; int ObjectIndex, int ObjectSerialNumber
		    AddWeakObject()
	    elseif (v.class == 'LazyObjectProperty') then
		    --size=0x1C ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {int A,int B,int C,int D});
		    AddWeakObject()
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".TagAtLastTest",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x8
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectID.Guid.A",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0xC
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectID.Guid.B",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x10
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectID.Guid.C",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x14
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..".ObjectID.Guid.D",postConcat)
		    element.Vartype = vtDword
		    element.Offset = v.offset+addOffset+0x18
	    elseif (v.class == 'SoftObjectProperty') or (v.class == 'SoftClassProperty')  then
		    --size=0x24 ; WeakObjectProperty WeakPtr,int32 TagAtLastTest,TObjectID ObjectID (struct {FName AssetPathName, FString SubPathString});
		    AddSoftObjectPtr()
	    elseif (v.class == 'DelegateProperty') then
		    --size=0x10 ; WeakObjectProperty Object, FName FunctionName;
		    AddDelegate(structure,'',v.offset+addOffset)
	    elseif (v.class == 'MulticastInlineDelegateProperty') or (v.class == 'MulticastDelegateProperty') then
		    local mainName = nameConcat(preConcat,v.name,postConcat)
		    local mainOffset = v.offset+addOffset
		    local element = structure.addElement()
		    element.Name = mainName..'[AllocatorInstance]'
		    element.Offset = v.offset+addOffset
		    element.Vartype = vtPointer
		    local chlstr=createStructure("")
		    element.ChildStruct = chlstr
		    local newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayNum]'
		    newElement.Offset = mainOffset+8
		    newElement.Vartype = vtDword
		    newElement = structure.addElement()
		    newElement.Name = mainName..'[ArrayMax]'
		    newElement.Offset = mainOffset+12
		    newElement.Vartype = vtDword
		    local count = readInteger(Address+mainOffset+0x8)
		    if count > 0 then
			    --print('\t\tItems: '..count, 'Allowed: '..MAX_ALLOWED_SUBFIELDS)
			    count = count <= MAX_ALLOWED_SUBFIELDS and count or MAX_ALLOWED_SUBFIELDS
			    local premax = MAX_ALLOWED_SUBFIELDS
			    MAX_ALLOWED_SUBFIELDS = MAX_ALLOWED_SUBFIELDS_INTERNAL
			    for i=0,count-1 do
				    local preConc = string.format('[%d]',i)
				    AddDelegate(chlstr,preConc,i*0x10)
			    end
			    MAX_ALLOWED_SUBFIELDS = premax
		    end
	    elseif (v.class == 'MulticastSparseDelegateProperty') or (v.class == 'ByteProperty')then
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name,postConcat)
		    element.Vartype = vtByte
		    element.Offset = v.offset+addOffset
	    elseif (v.class == 'IntefaceProperty') then
		    --size=0x10 ; UObject*	ObjectPointer,void* InterfacePointer;
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..'.ObjectPointer',postConcat)
		    element.Vartype = vtPointer
		    element.Offset = v.offset+addOffset
		    element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name..'.InterfacePointer',postConcat)
		    element.Vartype = vtPointer
		    element.Offset = v.offset+addOffset
	    else
		    local element = structure.addElement()
		    element.Name = nameConcat(preConcat,v.name,postConcat)
		    element.Vartype = GetCEType(v.class)
		    element.Offset = v.offset+addOffset
	    end
    end
    local function AutoFill(structure,baseadr,fields)
      for i=0,structure.Count-1 do
        local el1 = structure.Element[i]
        local el2 = structure.Element[i+1]
        if el2 then
          local pad = el2.Offset-(el1.ByteSize+el1.Offset)
          local ofst = el1.ByteSize+el1.Offset
          if pad > 0 then
	        --print(fu(el1.Offset), fu(el2.Offset), fu(ofst),pad)
	        structure.autoGuess(("%X"):format(baseadr+ofst), ofst, pad)
          end
        end
      end
    end
    local function AutoFillSubs(structure,baseadr,fields)
      --structure_beginUpdate(structure)
	  if not structure then return end
      local i,count=0,structure.Count
      repeat
        local el1 = structure.Element[i]
        local el2 = structure.Element[i+1]
        if el2 then
          local pad = el2.Offset-(el1.ByteSize+el1.Offset)
          local ofst = el1.ByteSize+el1.Offset
          --print(fu(el1.Offset), fu(el2.Offset), fu(pad), fu(ofst))
          if pad > 0 then
            structure.autoGuess(("%X"):format(baseadr), ofst, pad)
            count = structure.Count
            --i = i - 1
          end
        end
        i = i + 1
      until i >=count
      --structure_endUpdate(structure)
      return i, count
    end
    local function StructureAddUObjectElements(structure)
      local element = structure.addElement()
      element.Name = "vTable"
      element.Vartype = vtPointer
      element.Offset = 0
      element = structure.addElement()
      element.Name = "ObjectFlags"
      element.Vartype = vtDword
      element.Offset = 8
      element = structure.addElement()
      element.Name = "InternalIndex"
      element.Vartype = vtDword
      element.Offset = 0xC
      element = structure.addElement()
      element.Name = "ClassPrivate"
      element.Vartype = vtPointer
      element.Offset = 0x10
      element = structure.addElement()
      element.Name = "NamePrivate"
      element.Vartype = vtQword
      element.Offset = 0x18
      element = structure.addElement()
      element.Name = "OuterPrivate"
      element.Vartype = vtPointer
      element.Offset = 0x20
    end
    if #fields > 0 then
      local data = UE_GetObjectData(baseaddress)
      if data.ClassSize and UESettingsForm and UESettingsForm.ckbSDShowUObjectFields.Checked then
        StructureAddUObjectElements(structure)
      end
      for k,v in ipairs(fields) do
        print( fu(v.offset),'('..v.class..')', v.name)
	addStructElement(structure,v,baseaddress,OuterTypes.None)
      end
      local structsize = structure.Element[structure.Count-1]
      if bAllowFill and bAddMissingField() then
        AutoFill(structure,baseaddress,fields)
        for kk,vv in pairs(otherstructure) do
	  AutoFillSubs(vv.structure, vv.address)
	end
      end
      structsize = structsize.Offset+structsize.ByteSize
      --print(data.ClassSize-structsize)
      if data.ClassSize and bShowClassEnd() and data.ClassSize-structsize  > 0 then
        structure.autoGuess(("%X"):format(baseaddress+structsize), structsize, data.ClassSize-structsize)
      end
    else
      StructureAddUObjectElements(structure)
      if bAllowFill and bAddMissingField()  then
        local data = UE_GetObjectData(baseaddress)
        structure.autoGuess(("%X"):format(baseaddress+0x28),0x28, data.ClassSize-0x28)
        for kk,vv in pairs(otherstructure) do
	  vv.structure.autoGuess(("%X"):format(vv.address), 0, vv.size)
        end
      end
    end
    structure.endUpdate()
    if (UESettingsForm and UESettingsForm.ckbSDSaveSubStructures.Checked) then
	    structure.addToGlobalStructureList()
	    --print(structure.Name)
    end
    getLuaEngine().close()
    return true
  end

  unregisterStructureDissectOverride(structureDissectOverrideID)
  structureDissectOverrideID=nil

  unregisterStructureNameLookup(StructureNameLookupID)
  StructureNameLookupID=nil

  structureDissectOverrideID=registerStructureDissectOverride(DissectOverride)
  StructureNameLookupID=registerStructureNameLookup(GetObjectBaseOfAddress)
end
local structDissectorDis = function()
	unregisterStructureDissectOverride(structureDissectOverrideID)
	structureDissectOverrideID=nil

	unregisterStructureNameLookup(StructureNameLookupID)
	StructureNameLookupID=nil
end
menuItem.miUEStructDissect.OnClick = function(sender)
	if not(sender.Checked) then
		sender.Checked = true
		structDissectorEn()
	else
		sender.Checked = false
		structDissectorDis()
	end
end
function PrintFunParmInInvokeFormat(address)
  local boolprpoffsets = {}
  local function TypeBySize(size,prp)
    local ClassCastFlags = prp.ClassCastFlags
    CCFlags = UE_GetClassCastFlagNames(ClassCastFlags)
    local function IsFlagPresent(flags, flag)
      for k,v in pairs(flags) do
        if v == flag then return true end
      end
      return false
    end
    if     size==1 then return 'szByte','1'
    elseif size==2 then return 'szWord','2'
    elseif size==4 and not IsFlagPresent(CCFlags,"CASTCLASS_FFloatProperty") then return 'szDword','4'
    elseif size==4 and IsFlagPresent(CCFlags,"CASTCLASS_FFloatProperty") then return 'szFloat','4'
    elseif size==8 and IsFlagPresent(CCFlags,"CASTCLASS_FDoubleProperty") then return 'szDouble','8'
    elseif size==8 and prp.class=='DoubleProperty' then return 'szDouble','8'
    elseif size==8 then return 'szPointer','8'
    else return '<TYPE>','<SIZE>' --fails
    end
  end
  local function GetArrangedProps(prptbl)
    table.sort(prptbl, function(a, b)
      if a.offset==b.offset then
	return a.FieldMask < b.FieldMask
      else
	return a.offset<b.offset
      end
    end)
  end
  local function AddPadding(OutString, bytes, prm_str)
    local function AddStr(sz,tp)
      --<COMMA> --<COMMENT>
      local sbprm = prm_str:gsub('<VALUE>','0')
      sbprm = sbprm:gsub('<COMMA>',',')
      sbprm = sbprm:gsub('<COMMENT>','padding')
      sbprm = sbprm:gsub('<TYPE>',tp)
      --sbprm = sbprm:gsub('<SIZE>',sz)
      OutString = OutString..sbprm..'\n'
    end
    local t = {}
    t[8] = {sz='szQword'}
    t[8].num = math.floor(bytes/8)
    bytes = bytes%8
    t[4] = {sz='szDword'}
    t[4].num = math.floor(bytes/4)
    bytes = bytes%4
    t[2] = {sz='szWord'}
    t[2].num = math.floor(bytes/2)
    bytes = bytes%2
    t[1] = {sz='szByte'}
    t[1].num = math.floor(bytes/1)
    bytes = bytes%1
    local quot = bytes/1
    local rem  = bytes%1
    for i=1,8 do
      if (t[i]) then
        for j=1,t[i].num do
          AddStr(i,t[i].sz)
        end
      end
    end
    --for i=1,quot do AddStr(1,'szByte') end
    return OutString
  end
  local function ResolveParm(prm,prm_str)
    local function SetString(tp,sz,cmt,cma,vl)
      local str = prm_str:gsub("<TYPE>",tp)
      --str = str:gsub("<SIZE>",sz)
      str = str:gsub("<COMMENT>",cmt)
      str = str:gsub("<COMMA>",cma)
      str = str:gsub("<VALUE>",vl)
      return str
    end
    if (prm.class == "StructProperty") then
      GetArrangedProps(prm.SubFields)
      local parentsize = prm.size
      local parentOffset = prm.offset
      local byte = parentOffset
      local SumStr = ""
      local calcSize = 0
      for i=1,#prm.SubFields do
        local sub = prm.SubFields[i]
        local offset = sub.offset
        local size = sub.size
        --calcSize = calcSize+size
        local str = ''
        if offset > byte then
          str = str..AddPadding(str,offset-byte,prm_str)
          byte = byte + (offset-byte)
          --calcSize = calcSize + (offset-byte)
        end
        local _type,_size = TypeBySize(size,sub)
        local bl,st,bnoadd = ResolveParm(sub,prm_str)
        if bl then
          str = str..st
        else
          str = str..prm_str:gsub("<TYPE>",_type)
          --str = str:gsub("<SIZE>",_size)
          str = str:gsub("<COMMENT>",sub.class.."  "..sub.name..'('..("%X->%X"):format(sub.offset,sub.offset+sub.size)..')')
          str = str:gsub("<COMMA>",",")
          str = str:gsub("<VALUE>"," ")
          str = str..'\n'
        end
        byte = bnoadd and byte or byte+size
        --print(sub.offset,sub.size)
        calcSize = i==#prm.SubFields and sub.size+sub.offset or 0
        SumStr = SumStr..str
      end
      if calcSize < parentsize+prm.offset then
        SumStr = AddPadding(SumStr,parentsize-calcSize,prm_str)
      end
      return true,SumStr
    elseif (prm.class == "ArrayProperty") or (prm.class=='MulticastInlineDelegateProperty') then
      local retStr = ""
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'AllocatorInstance'..'('..("%X->%X"):format(prm.offset,prm.offset+8)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ArrayNum'..'('..("%X->%X"):format(prm.offset+8,prm.offset+12)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ArrayMax'..'('..("%X->%X"):format(prm.offset+12,prm.offset+16)..')',","," ")..'\n'
      return true,retStr
    elseif (prm.class == "StrProperty") then
      local retStr = ""
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'AllocatorInstance'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ArrayNum'..'('..("%X"):format(prm.offset+8)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ArrayMax'..'('..("%X"):format(prm.offset+12)..')',","," ")..'\n'
      return true,retStr
    elseif (prm.class == "NameProperty") then
      local retStr = ""
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ComparisionIndex'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Number'..'('..("%X"):format(prm.offset+4)..')',","," ")..'\n'
      return true,retStr
    elseif (prm.class == "MapProperty") or (prm.class == "SetProperty")  then --size=0x50
      if prm.size ~=0x50 then print('Error: MapPropery should be of 0x50 size')
      else
	local retStr = ""
	retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'Array.AllocatorInstance'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Array.ArrayNum'..'('..("%X"):format(prm.offset+8)..')',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Array.ArrayMax'..'('..("%X"):format(prm.offset+0xC)..')',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.InlineData[0]'..'('..("%X"):format(prm.offset+0x10)..') --binary format of ArrayNum eg 2=>3,5=>31',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.InlineData[1]'..'('..("%X"):format(prm.offset+0x14)..')',",","0")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.InlineData[2]'..'('..("%X"):format(prm.offset+0x18)..')',",","0")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.InlineData[3]'..'('..("%X"):format(prm.offset+0x1C)..')',",","0")..'\n'
	retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.SecondaryData.Data'..'('..("%X"):format(prm.offset+0x20)..')',",","0")..'\n'
	retStr = retStr..SetString("szDword","4",'(==ArrayNum)'..prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.NumBits'..'('..("%X"):format(prm.offset+0x28)..')',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.AllocationFlags.AllocatorInstance.MaxBits'..'('..("%X"):format(prm.offset+0x2C)..')',","," ")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.FirstFreeIndex'..'('..("%X"):format(prm.offset+0x30)..')',",","-1")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'Elements.NumFreeIndices'..'('..("%X"):format(prm.offset+0x34)..')',",","0")..'\n'
	retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'Hash.InlineData[0]'..'('..("%X"):format(prm.offset+0x38)..')',",","0")..'\n'
	retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'Hash.SecondaryData.Data'..'('..("%X"):format(prm.offset+0x40)..')',",","0")..'\n'
	retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'HashSize'..'('..("%X"):format(prm.offset+0x48)..')',",","0")..'\n'
        return true, retStr
      end
    elseif (prm.class == "DelegateProperty") or (prm.class == 'MulticastDelegateProperty') then
      local retStr = ""
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectIndex'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectSerialNumber'..'('..("%X"):format(prm.offset+4)..')',","," ")..'\n'
      retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'FunctionName'..'('..("%X"):format(prm.offset+8)..')',","," ")..'\n'
      return true, retStr
    elseif (prm.class == "WeakObjectProperty") then
      local retStr = ""
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectIndex'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectSerialNumber'..'('..("%X"):format(prm.offset+4)..')',","," ")..'\n'
      return true,retStr
    elseif (prm.class == "SoftClassProperty") or (prm.class == "SoftObjectProperty") or (prm.class == "AssetClassProperty") or (prm.class == "AssetObjectProperty") then
      local retStr = ""
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectIndex'..'('..("%X"):format(prm.offset)..')',",","-1")..'\n'
      retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'ObjectSerialNumber'..'('..("%X"):format(prm.offset+4)..')',",","0")..'\n'
      retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'TagAtLastTest'..'('..("%X"):format(prm.offset+8)..')',",","0")..'\n'
      retStr = retStr..SetString("szQword","8",prm.class.."  "..prm.name..'.'..'AssetPathName'..'('..("%X"):format(prm.offset+0x10)..')',","," ")..'\n'
      --retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'AssetPathName.Number'..'('..("%X"):format(prm.offset+0x14)..')',","," ")..'\n'
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'SubPathString.AllocatorInstance'..'('..("%X"):format(prm.offset+0x18)..')',",","0")..'\n'
      if prm.size > 0x20 then
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'SubPathString.ArrayNum'..'('..("%X"):format(prm.offset+0x20)..')',",","0")..'\n'
	retStr = retStr..SetString("szDword","4",prm.class.."  "..prm.name..'.'..'SubPathString.ArrayMax'..'('..("%X"):format(prm.offset+0x24)..')',",","0")..'\n'
      end
      if prm.size > 0x28 then
        retStr = retStr..AddPadding(retStr, prm.size-0x28, prm_str)
      end
      return true,retStr
    elseif (prm.class == "TextProperty") then
      local retStr = ""
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'Object'..'('..("%X"):format(prm.offset)..')',","," ")..'\n'
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'ReferenceController'..'('..("%X"):format(prm.offset+8)..')',","," ")..'\n'
      retStr = retStr..SetString("szPointer","8",prm.class.."  "..prm.name..'.'..'Flags'..'('..("%X"):format(prm.offset+16)..')',","," ")..'\n'
      return true,retStr
    elseif (prm.class == "BoolProperty") then
      local _type,_size = TypeBySize(prm.size,prm)
      local s = SetString(_type,_size,prm.class.."  "..prm.name..("(%X->%X)[%d]"):format(prm.offset,prm.offset+prm.size,prm.FieldMask),','," ")..'\n'
      if (boolprpoffsets[tostring(prm.offset)]) then
        return true, s:gsub('\t','\t--'), true
      else
        boolprpoffsets[tostring(prm.offset)] = prm.FieldMask
      end
      return true, s
    else
      return false
    end
  end

  local function PrintFunctionParameterStruct(func)
    func = UE_CheckAddressAsObject(func)
    if func==0 then return error("Not valid UFunction UObject") end
    local output = [[local <Func>_Param = {
    <PARAM>
    }]]
    --local prm_str = "\t{type=<TYPE>,size=<SIZE>,value=<VALUE>}<COMMA> --<COMMENT>"
    local prm_str = "\t{type=<TYPE>,value=<VALUE>}<COMMA> --<COMMENT>"
    local data = UE_GetFunctionData(func)
    local bAllprm = UESettingsForm and UESettingsForm.ckbDCBPParameters.Checked or false
        --bAllprm = bAllprm and 1 or 0
    local params = UE_GetFunctionParameters(func,bAllprm)
    GetArrangedProps(params)
    output = output:gsub('<Func>',data.Name)
    local byte = 0
    if (#params > 0) then
     local TotalStr = ""
     for i=1,#params do
       local prm = params[i]
       local offset = prm.offset
       local size = prm.size
       local str = ''
       if offset > byte then
        str = str..AddPadding(str,offset-byte,prm_str)
        byte = byte + (offset-byte)
       end
       local _type,_size = TypeBySize(size,prm)
       if byte ~= offset then str = str..'--[[ offset match error ]]\n' end
       local bl,st,bnoadd = ResolveParm(prm,prm_str)
       if bl then
         str = str..st
       else
         str = str..prm_str:gsub("<TYPE>",_type)
         --str = str:gsub("<SIZE>",_size)
         prm.class = #prm.SpecialName>0 and prm.SpecialName or prm.class
         str = str:gsub("<COMMENT>",prm.class.."  "..prm.name..'('..("%X->%X"):format(prm.offset,prm.offset+prm.size)..')')
         local comma =  i < #params and "," or ""
         str = str:gsub("<COMMA>",comma)
         str = str:gsub("<VALUE>"," ")
         str = str..'\n'
       end
       TotalStr = TotalStr..str
       byte = bnoadd and byte or byte+size
       --print(size,TotalStr)
     end
     --TotalStr = string.char(TotalStr:byte(#TotalStr))== ',' and TotalStr:sub(1,#TotalStr-1) or TotalStr
     output = output:gsub('<PARAM>',TotalStr)
    else
     output = output:gsub('<PARAM>',"")
    end

    getLuaEngine().mOutput.clear()
    print(output)
  end
  PrintFunctionParameterStruct(address)
end
FORMLABEL = {}

local function clearAllMethodsAndFields(form)
  form.lvFields.Items.clear()
  form.lvMethods.Items.clear()
  form.gbClassInformation.Caption='Class Information'
  form.comboFieldBaseAddress.Items.clear()
  form.comboFieldBaseAddress.ItemIndex = -1
  form.comboFieldBaseAddress.Text = ""
  if form.lvFieldsTree then form.lvFieldsTree.clear() end
end
function InstallFieldsAndMethods(form,fields,functions,bforceclr)
    for k,v in pairs(FORMLABEL) do
		v.destroy()
	end
	FORMLABEL = {}
	local propertyTypes = {}
		propertyTypes.Unknown = 0
		propertyTypes.BoolProperty = 1
		propertyTypes.ObjectProperty = 2
		propertyTypes.StructProperty = 3
		propertyTypes.EnumProperty = 4
		propertyTypes.ArrayProperty = 5
		propertyTypes.MapProperty = 6
		propertyTypes.ClassProperty = 7
		propertyTypes.SetProperty = 8
	if not(form) then form = UEForm end
        --UEForm.lvFieldsTree.clear()
	if bforceclr then clearAllMethodsAndFields(form) end
	if (fields and type(fields)=='table'and #fields > 0) then
	 table.sort(fields, function(a, b)
				  if (a.offset == b.offset) then
					 return a.FieldMask < b.FieldMask
				  end
				  return a.offset < b.offset
				 end)
	 --form.lvFields.beginUpdate()
	  local prog = form.scanProgress
	  local pbl = nil
	 if prog then
		pbl =createLabel(prog)
		pbl.Name = 'FieldLabel'
		FORMLABEL[pbl.Name]=pbl
		pbl.Caption=("Fields Iterated: 0/%d"):format(#fields)
		pbl.AnchorSideLeft.Control=prog
		pbl.AnchorSideLeft.Side=asrCenter

		pbl.AnchorSideTop.Control=prog
		pbl.AnchorSideTop.Side=asrCenter
		local pheight = prog.Height
		pbl.Height = prog.Height
		prog.setMin(0)
		prog.setMax(#fields-1)
		prog.Position = 0
	 end
	 local b = GHUESettings and GHUESettings.DataCollector and GHUESettings.DataCollector.ckbDCExpandStructs~=nil
	 b = not(b) and true or GHUESettings.DataCollector.ckbDCExpandStructs
	 local function AddItem(form,v)
		 if (b and v.PropertyType == propertyTypes.StructProperty and #v.SubFields>0) then
			for i=1,#v.SubFields do
				v.SubFields[i].name = v.SpecialName~='' and '('..v.SpecialName..') '..v.SubFields[i].name or v.SubFields[i].name
				AddItem(form,v.SubFields[i])
			end
		 else
		   if form.lvFieldsTree then
			  local node=form.lvFieldsTree.addChild(nil)
			  form.lvFieldsTree.setNodeDataAsInteger(node, createRef(v))
			  if (v.class == "ObjectProperty") or (v.class == "StructProperty")  then
				form.lvFieldsTree.HasChildren[node]=true
			  end
			  form.lvFieldsTree.Selected[node] = true
			  form.lvFieldsTree.Selected[node] = false
		   else
			   local itm = form.lvFields.Items.add()
			   itm.Data = k
			   itm.Caption = string.format('%.3X',v.offset)
			   local name = v.name
				if (v.FieldMask~=-1) then
				   name = name..'['..v.FieldMask..']'
				end
				local objName = v.class
				if     (v.class == "ObjectProperty") or (v.class == "ClassProperty") or (v.class == "StructProperty") then
					objName = objName..'('..v.SpecialName..')'
				elseif (v.class == "ByteProperty") or (v.class == "EnumProperty") then
					local sp = v.SpecialName =="" and "" or '('..v.SpecialName..')'
					objName = objName..sp
				elseif ((v.class=="ArrayProperty" or v.class=="SetProperty") and #v.SubFields > 0) then
					local kls = v.SubFields[1].class:gsub('Property','')
					local spn = v.SubFields[1].SpecialName
					local inName = spn=="" and kls or kls..'('..spn..')'
					objName = objName..'<'..inName..'>'
				elseif (v.class=="MapProperty" and #v.SubFields == 2) then
					local kls = v.SubFields[1].class:gsub('Property','')
					local spn = v.SubFields[1].SpecialName
					local inName = spn=="" and kls or kls..'('..spn..')'
					kls = v.SubFields[2].class:gsub('Property','')
					spn = v.SubFields[2].SpecialName
					local inName2 = spn=="" and kls or kls..'('..spn..')'
					objName = objName..'<'..inName..','..inName2..'>'
				end
			   itm.SubItems.add(name)
			   itm.SubItems.add(objName) --property type
		   end
		 end
	 end
	 local count = 0
	 --if UEForm.lvFieldsTree then UEForm.lvFieldsTree.beginUpdate() end
	 for k,v in pairs(fields) do
		AddItem(form,v)
		count = count+1
		if pbl then
			pbl.Caption=("Fields Iterated: %d/%d"):format(count,#fields)
			prog.stepBy(1)
		end
	 end
	 if pbl then
		pbl.Caption=("Fields Iterated: %d/%d"):format(#fields,#fields)
		prog.Position = 0
		if pbl then pbl.destroy() end
	 end
	end

	if (functions and type(functions)=='table' and #functions > 0) then
		 table.sort(functions, function(a, b) return a.name:upper() < b.name:upper() end)
		 --form.lvMethods.beginUpdate()
		 local prog = form.scanProgress
		 local pbl = nil
		 if prog then
		  pbl=createLabel(prog)
		  pbl.Name = 'FunctionLabel'
		  FORMLABEL[pbl.Name]=pbl
		  pbl.Caption=("Functions Iterated: 0/%d"):format(#functions)
		  pbl.AnchorSideLeft.Control=prog
		  pbl.AnchorSideLeft.Side=asrCenter
		  pbl.AnchorSideTop.Control=prog
		  pbl.AnchorSideTop.Side=asrCenter
		  local pheight = prog.Height
		  pbl.Height = prog.Height
		  prog.setMin(0)
		  prog.setMax(#functions-1)
		  prog.Position = 0
		 end
		 local count = 0
		 local bAllprm = UESettingsForm and UESettingsForm.ckbDCBPParameters.Checked or false
		 --bAllprm = bAllprm and 1 or 0
		 for k,v in pairs(functions) do
			--createThread(function(thread) thread.freeOnTerminate(true)
			 local itm = form.lvMethods.Items.add()
			 itm.Data = v.execFunc
			 itm.Caption = v.name
			 itm.SubItems.add(v.owner) --Owner
			 local returnType = ""
			 local prms = v.ParamsCount > 0 and UE_GetFunctionParameters(v.ufunction, bAllprm) or {}
			 if type(prms)=='table' then
				 local param = '('
				 for i=1,#prms do
				     local prm = prms[i]
					 local modeType;
					 if (prm.PropertyType == propertyTypes.ObjectProperty or prm.PropertyType == propertyTypes.ClassProperty) and prm.SpecialName~="" then --ObjectProperty, ClassProperty
						modeType = prm.SpecialName..'['..prm.class:gsub('Property','')..']'
					 --elseif prm.PropertyType == propertyTypes.ClassProperty and prm.SpecialName~="" then --ClassProperty
						--modeType = prm.SpecialName..'['..prm.class:gsub('Property','')..']'
					 elseif prm.PropertyType == propertyTypes.StructProperty and prm.SpecialName~="" then --StructProperty
						modeType = prm.SpecialName..'['..prm.class:gsub('Property','')..']'
					 elseif prm.PropertyType == propertyTypes.EnumProperty and prm.SpecialName~="" and prm.InnerSize~=-1 then --EnumProperty
						modeType = prm.SpecialName..'['..prm.class:gsub('Property','')..'_'..(prm.InnerSize*8)..'bits]'
					 elseif (prm.PropertyType == propertyTypes.ArrayProperty or prm.class =='SetProperty') and #prm.SubFields > 0 then --ArrayProperty
						local infld = prm.SubFields[1]
						local infldkls = infld.class:gsub('Property','')
						local inName = infld.SpecialName=="" and infldkls or infldkls.."("..infld.SpecialName..")"
						modeType = prm.class:gsub('Property','')..'<'..inName..'>'
					 elseif prm.PropertyType == propertyTypes.MapProperty and #prm.SubFields == 2 then --MapProperty
						local infld1 = prm.SubFields[1]
						local infld2 = prm.SubFields[2]
						local infldkls1 = infld1.class:gsub('Property','')
						local infldkls2 = infld2.class:gsub('Property','')
						local inName1 = infld1.SpecialName=="" and infldkls1 or infldkls1.."("..infld1.SpecialName..")"
						local inName2 = infld2.SpecialName=="" and infldkls2 or infldkls2.."("..infld2.SpecialName..")"
						modeType = prm.class:gsub('Property','')..'<'..inName1..","..inName2..'>'
					 else
						modeType = prm.class:gsub('Property','')
					 end
					 if (prm.name:find('ReturnValue') and i==#prms) then
					   returnType = modeType..' '
					 else
					   local flgs = UE_GetPropertyFlagNames(prm.PropertyFlags)
					   local pd = ""
					   for k,v in pairs(flgs) do
						if (k=="CPF_OutParm" or v=="CPF_OutParm") then
							pd = "&"
							break;
						end
					   end
					   param = param..modeType..pd..' '..prm.name
					 end
					 --print(param)
					 if i<#prms and not(prms[i+1].name=='ReturnValue') then param = param..', ' end
				 end
				 param = returnType..param..')'
				 itm.SubItems.add(param) --Parameters
				 itm.SubItems.add(fu(v.ufunction))  --UFunction
			 else
				 itm.SubItems.add('-') --Parameters
				 itm.SubItems.add(fu(v.ufunction))  --UFunction
			 end
			 count = count+1
			 if pbl then
				pbl.Caption=("Functions Iterated: %d/%d"):format(count,#functions)
				prog.stepBy(1)
			 end
		 end

		 if pbl then prog.Position = 0; pbl.destroy() end
		 --form.lvMethods.endUpdate()
	end
	form.scanProgress.setMin(0)
	form.scanProgress.Position = 0
	for k,v in pairs(FORMLABEL) do
		v.destroy()
	end
	FORMLABEL = {}
	--end)
end

menuItem.miDataCollectorForm.OnClick = function(sender)
	--Copied from dotnetinfo.lua
	if not(UEForm) then
	   local formPath = getCheatEngineDir()..[[\autorun\forms\GH_UE_Dumper.frm]]
	   UEForm = createFormFromFile(formPath)
	   UEForm.Name = 'UEForm'
	   UEForm.Caption = 'Guided Hacking Unreal Engine Dumper v'..cversion
	end
	local frm = CreateSettingsForm()
	if frm and UEForm.miSettings then UEForm.miSettings.OnClick = function() frm.Show() end end
    UEForm.show()
	UEForm.Position = poScreenCenter
	local function GetPrmsForDecompiler()
		local t = {}
		local dec = GHUESettings.Decompiler
		if (GHUESettings and dec) then
			t.bubf = dec.ckbDeCmDontUbergraph
			t.scnd = dec.ckbDeCmDontScriptNode 
			t.owcl = dec.ckbDeCmDontOwnerClass
			t.lcpr = dec.ckbDeCmShowLocalProp  
			t.inpr = dec.ckbDeCmShowInstanceProp  
			t.dfpr = dec.ckbDeCmShowDefaultProp 
			t.prtp = dec.ckbDeCmShowPropertyType 
			t.ennm = dec.ckbDeCmShowEnumNames 
			t.bcin = dec.ckbDeCmShowBasicInfo
		end
		return t
	end
	local function FindInListBox(listbox)
	  local fd=createFindDialog(UEForm)
	  fd.Options='[frDown, frHideWholeWord,  frHideEntireScope, frHideUpDown]'
	  fd.Title='Search in '..listbox.name

	  fd.OnFind=function()
		local caseSensitive=fd.Options:find('frMatchCase')~=nil
		local start=listbox.ItemIndex
		start=start+1
		
		local needle=fd.FindText
		if not caseSensitive then
		  needle=needle:upper()
		end
		
		for i=start, listbox.Items.Count-1 do      
		  local element=listbox.Items[i]      
		  
		  if not caseSensitive then
			element=element:upper()
		  end
			   
		  if element:find(needle,0,true)~=nil then
			listbox.itemIndex=i
			return
		  end
		end
		beep() 
	  end
	  
	  
	  fd.execute()  

	  local x,y
	  x=(listbox.height / 2)
	  x=x-(fd.height/2)
	  
	  y=(listbox.width / 2)
	  x=y-(fd.width/2)
	  
	  x,y=listbox.clientToScreen(x,y)
	  fd.top=y
	  fd.left=x
	end
	local function FindInListView(listview)
	  local fd=createFindDialog(UEForm)
	  fd.Options='[frDown, frHideWholeWord,  frHideEntireScope, frHideUpDown]'
	  fd.Title='Search in '..listview.name

	  fd.OnFind=function()
		local caseSensitive=fd.Options:find('frMatchCase')~=nil
		local start=listview.ItemIndex
		start=start+1
		
		local needle=fd.FindText
		if not caseSensitive then
		  needle=needle:upper()
		end
		
		for i=start, listview.Items.Count-1 do      
		  local element=listview.Items[i]      
		  local caption = element.Caption
		  if not caseSensitive then
			caption=caption:upper()
		  end
			   
		  if caption:find(needle,0,true)~=nil then
			listview.itemIndex=i
			return
		  end
		  for j=0, element.SubItems.Count-1 do
			local subElement = element.SubItems[j]
			if subElement:find(needle,0,true)~=nil then
				listview.itemIndex=i
				return
			end
		  end 
		end
		beep() 
	  end
	  
	  
	  fd.execute()  

	  local x,y
	  x=(listview.height / 2)
	  x=x-(fd.height/2)
	  
	  y=(listview.top / 2)
	  y=y-(fd.top/4)
	  
	  x,y=listview.clientToScreen(x,y)
	  fd.top=y
	  fd.left=x
	end

	
	local function InheritanceResize(gbInheritance, now)
	  if delayedResize==nil then
		local f=function()
		  local i,x,y
		  local width=gbInheritance.ClientWidth

		  x=0
		  y=0

		  for i=0 , gbInheritance.ControlCount-1 do
			local c=gbInheritance.Control[i]
			if (x~=0) and (x+c.Width>width) then
			  x=0
			  y=y+c.height
			end

			c.Left=2+x
			c.Top=y


			x=x+c.Width+1
		  end
		  delayedResize=nil
		end

		if now then
		  f()
		else
		  delayedResize=createTimer(100,f)
		end
	  else
		--reset timer
		delayedResize.Enabled=false
		delayedResize.Enabled=true
	  end
	end
	local function InstallInheritance(Inherit,groupbox,sep,bDoNotHighlightFirstOne)
	  local function LabelPopup(sender)
		writeToClipboard(sender.Owner.Owner.Caption)
	  end
	  local function DumpAllInheritedClasses(sender)
		local klass = sender.Owner.Owner.Caption
		UE_DumpInheritedClassesOf(klass)
	  end
	  local function DumpClassesWithInstanceof(sender)
		local klass = sender.Owner.Owner.Caption
		UE_DumpAllClassesWithInstanceOf(klass)
	  end
	  local function DecompileWholeClass(sender)
		if (UE_GetDecompilerState()=='Working') then
			showMessage('Decompiler state','Decompiler is already working, cannot start another decompilation')
			return
		end
		local klass = sender.Owner.Owner.Caption
		local t = GetPrmsForDecompiler()
		UE_DecompileScript(klass, nil, nil, nil, t.bubf, t.scnd, t.owcl, t.lcpr, t.inpr, t.dfpr, t.prtp, t.ennm, t.bcin)
	  end
	  --delete previous controls
	  groupbox = groupbox and groupbox or UEForm.gbInheritance
	  sep = sep and sep or '->'
	  while groupbox.ControlCount>0 do
		groupbox.Control[0].destroy()
	  end
	  local ClassList = {}
	  for i=1,#Inherit do
		  ClassList[i]=Inherit[i]
	  end
	  if (ClassList and #ClassList>0) then
		 for i=1,#ClassList do
			l=createLabel(groupbox)
			local fullname=ClassList[i].name
			l.Caption=fullname
			ClassList[i].Label=l

			if i==1 and not(bDoNotHighlightFirstOne) then
			  l.Font.Style="[fsBold]"
			else
			  l.Font.Style="[fsUnderline]"
			  l.Font.Color=clBlue
			end
			l.Cursor=crHandPoint
			InheritanceResize(groupbox, true)
			l.OnClick=function(s)
			  local j
			  for j=1,#ClassList do
				if j==i then
				  ClassList[j].Label.Font.Color=clWindowText
				  ClassList[j].Label.Font.Style="[fsBold]"
				  if (ClassList[j].klass) then
					clearAllMethodsAndFields(UEForm)
					--createThread(function()
						local IsSettings = GHUESettings and GHUESettings.DataCollector and GHUESettings.DataCollector.ckbDCShowParentFields~=nil
						local ssd = not(IsSettings) and 1 or (GHUESettings.DataCollector.ckbDCShowParentFields and 1 or 0)
						local fields = UE_GetFieldsOfClass(ClassList[j].name,ssd)
						ssd = not(IsSettings) and 1 or (GHUESettings.DataCollector.ckbDCShowParentFuncs and 1 or 0)
						local functions = UE_GetFunctionsOfClass(ClassList[j].name,ssd)
						InstallFieldsAndMethods(UEForm,fields,functions)
					--end)
					local klss = UEForm.lbClasses
					local itemm = klss.Items[klss.getItemIndex()]
					if itemm then
					   UEForm.gbClassInformation.Caption = itemm
					else
						UEForm.gbClassInformation.Caption = ClassList[j].name
					end
				  end
				else
				  ClassList[j].Label.Font.Style="[fsUnderline]"
				  ClassList[j].Label.Font.Color=clBlue
				end
			  end
			  InheritanceResize(groupbox, true)
			end
			local ppmen   = createPopupMenu(l)
			local menItem = createMenuItem(ppmen)
			menItem.Caption = "Copy"
			menItem.OnClick = LabelPopup
			ppmen.Items.Add(menItem)
			menItem = createMenuItem(ppmen)
			menItem.Caption = "Dump Inherited Classes"
			menItem.OnClick = DumpAllInheritedClasses
			ppmen.Items.Add(menItem)
			menItem = createMenuItem(ppmen)
			menItem.Caption = "Dump Classes with Instance of this class"
			menItem.OnClick = DumpClassesWithInstanceof
			ppmen.Items.Add(menItem)
			menItem = createMenuItem(ppmen)
			menItem.Caption = "Decompile Class"
			menItem.OnClick = DecompileWholeClass
			ppmen.Items.Add(menItem)
			l.PopupMenu = ppmen
			if i~=#ClassList then --not the last item
			  l=createLabel(groupbox)
			  l.Caption=sep
			end
		  end
	  end
	  --create new controls
	end
	local function InstallInterfaces(Interfaces)
	  if not UEForm.gbInterfaces then print('"UEForm.gbInterfaces" was null') return end
	  UEForm.gbInterfaces.Visible = false;
	  if not Interfaces or #Interfaces<=0 then return end
	  UEForm.gbInterfaces.Visible = true;
	  --print('installing interfaces')
	  InstallInheritance(Interfaces,UEForm.gbInterfaces,', ',true)
	end
	local function GetArrangedTable(MainTable)
	  local tTable = {}
	  for k,v in pairs(MainTable) do
		--tTable[#tTable+1] = k
	    tTable[#tTable+1] = v.className
	  end
	  table.sort(tTable, function(a, b) return a:upper() < b:upper() end)
	  return tTable
	end
	local function GetItemByNameFromClasses(_table, name, index)
		index = index > 1 and index or 1
		_table = _table and _table or UNIQUE_CLASSES
		local c = 1
		for k,v in pairs(_table) do
		  if v.className==name then 
			  if c==index then
				return v
			  else
				c = c+1
			  end
		  end
		end
	end

	local function ReadStringFromPipe()
	  local retStr = ""
	  local strc = UnrealPipe.readWord()
	  retStr = UnrealPipe.readString(strc);
	  return retStr
	end
	local function InitUE4Loud(form, progressbar)
	  if (type(UEForm)~='userdata') then return end
	  OBJECTS_STORE = {}
	  UNIQUE_CLASSES = {}
	  local count = 0
	  local klscount = 0
	  local prog = progressbar
	  form.ScanButton.Enabled = false
	  --print(Total)
	  Total = UE_CountObjects()
	  prog.setMin(0)
	  prog.setMax(Total-1)
	  prog.Position = 0  --[[
	  local pbl=createLabel(prog)
	  pbl.Caption=("Objects Scanned: 0/%d"):format(Total)
	  pbl.AnchorSideLeft.Control=prog
	  pbl.AnchorSideLeft.Side=asrCenter

	  pbl.AnchorSideTop.Control=prog
	  pbl.AnchorSideTop.Side=asrCenter
	  pbl.Height = prog.Height  --]]
	  for i=0x0,Total-1 do
		local obj = UE_GetObjectAt(i)
		local objectx = {}
		objectx.address = obj.UObject
		objectx.classAddress = UE_GetObjectClass( objectx.address )
		--objectx.size = UnrealPipe.readDword()
		objectx.className = UE_GetObjectClassName( objectx.address )
		objectx.classOuterName = UE_GetObjectOuterName(UE_GetObjectOuter( objectx.classAddress ))
		OBJECTS_STORE[#OBJECTS_STORE+1]=objectx
		if not(UNIQUE_CLASSES[objectx.classAddress]) then
		  UNIQUE_CLASSES[objectx.classAddress] = objectx
		  klscount = klscount+1
		end
		--[[
		  UnrealPipe.lock()
		  UnrealPipe.writeByte(4) --ObjectAtIndex
		  UnrealPipe.writeDword(i)
		  if (UnrealPipe.readByte()==1) then
			if (UnrealPipe.readByte()==1) then
				local objectx = {}
				objectx.address = UnrealPipe.readQword()
				objectx.classAddress = UnrealPipe.readQword()
				objectx.size = UnrealPipe.readDword()
				objectx.className = ReadStringFromPipe()
				OBJECTS_STORE[#OBJECTS_STORE+1]=objectx
				if not(UNIQUE_CLASSES[objectx.classAddress]) then
				  UNIQUE_CLASSES[objectx.classAddress] = objectx
				  klscount = klscount+1
				end
				count = count+1
			end
		  end
		  UnrealPipe.unlock() --]]
		  --pbl.Caption = ("Objects Scanned: %d/%d"):format(i,Total)
		  prog.stepBy(1)
	  end
	  prog.setPosition(0)
	  form.lblObjCount.Caption = 'Total Objects: '..count
	  form.lblClasses.Caption = 'Total Classes: '..klscount
	  form.ScanButton.Enabled = true
	  --pbl.destroy()
	  beep()
	end
	local function InitUE4Fast(form, progressbar)
	  OBJECTS_STORE = {}
	  UNIQUE_CLASSES = {}
	  local count = 0
	  local klscount = 0
	  local prog = progressbar
	  form.ScanButton.Enabled = false
	  --print(Total)
	  local klasses = UE_GetAllSubObjectsOfClass('Class')
	  Total = #klasses
	  prog.setMin(0)
	  prog.setMax(Total-1)
	  prog.Position = 0  --[[
	  local pbl=createLabel(prog)
	  pbl.Caption=("Objects Scanned: 0/%d"):format(Total)
	  pbl.AnchorSideLeft.Control=prog
	  pbl.AnchorSideLeft.Side=asrCenter

	  pbl.AnchorSideTop.Control=prog
	  pbl.AnchorSideTop.Side=asrCenter
	  pbl.Height = prog.Height  --]]
	  for i=1,Total do
	    local nm = UE_GetObjectName(klasses[i])
		local objectx = {}
		objectx.classAddress = klasses[i]
		objectx.className = nm
		objectx.classOuterName = UE_GetObjectOuterName(UE_GetObjectOuter( klasses[i] ))
		if not(UNIQUE_CLASSES[klasses[i]]) then
		  UNIQUE_CLASSES[klasses[i]] = objectx
		  klscount = klscount+1
		end
		prog.stepBy(1)
	  end
	  prog.setPosition(0)
	  form.lblObjCount.Caption = 'Total Objects: '..UE_CountObjects()
	  form.lblClasses.Caption = 'Total Classes: '..klscount
	  form.ScanButton.Enabled = true
	  --pbl.destroy()
	  beep()
	end
	local function UEForm_ScanButtonClick(sender)
	  if (type(InitUE4Loud)~= 'function') then print('Please enable the \"Unreal Engine Initialize\" first!') return end
	  UEForm.btnClassList.Caption= 'Init Class List'
	  UEForm.lblObjCount.Caption = 'Total Objects: '..0
	  UEForm.lblClasses.Caption = 'Total Classes: '..0
	  createThread(function(thread) 
	    if UESettingsForm and UESettingsForm.ckbDCQuickScan.Checked then
			--print('FastScan')
			InitUE4Fast(UEForm, UEForm.scanProgress)
		else
			InitUE4Loud(UEForm, UEForm.scanProgress)
		end
	  end)
	end
	local function UEForm_btnClassListClick(sender)
	  if (sender.Caption=='Init Class List') then
		  local arrangedClasses = GetArrangedTable(UNIQUE_CLASSES)
		  sender.Caption = 'Clear Class List'
		  UEForm.lbClasses.clear()
		  local txtBx = UEForm.edtClassFilter
		  local all = txtBx.Text==""
		  local klssTextBox = UEForm.lbClasses
		  for k,v in pairs(arrangedClasses) do
			  if not(all) and (v:lower():find(txtBx.Text:lower(),1,true)) then
				 klssTextBox.Items.Add(v)
			  elseif (all) then
				  klssTextBox.Items.Add(v)
			  end
		  end
	  else
		  sender.Caption = 'Init Class List'
		  UEForm.lbClasses.clear()
	  end
	end
	local function GetSpecificObjectByName(className,objName)
	  local classes = UE_GetAllObjectsOfClass(className)
	  for k,v in pairs(classes) do
		  if v.name:find(objName) then return v end
	  end
	end
	local function GetFunctionByName(object,functionName)
	  if not(object) or not(readPointer(object)) then return nil end
	  if (UE_CheckAddressAsObject(object)==0) then return end
	  if object==0 then print("Invalid object") return end
	  local funcs = UE_GetFunctionsOfObject(object,1)
	  for k,v in pairs(funcs) do
		  if v.name == functionName then return v end
	  end
	end
	local function EnumInterfaceClasses()
	  local klss = {}
	  for k,v in pairs(UE_GetAllSubObjectsOfClass('Interface')) do
		if UE_GetObjectName(v):find('Default__') then
		  klss[UE_GetObjectClassName(v)] = v
		end
	  end
	  return klss
	end
	local function GetImplementedInterfaces(object)
	  assert(UE_CheckAddressAsObject(object)==object,'Error: "GetImplementedInterfaces" Says invalid object parameter: '..fu(object))
	  local interfaces = EnumInterfaceClasses()
	  local KismetSystemLibrary = GetSpecificObjectByName('KismetSystemLibrary','Default').obj
	  local DoesImplementInterface  = GetFunctionByName(KismetSystemLibrary,'DoesImplementInterface').ufunction
	  local implemented = {}
	  for k,v in pairs(interfaces) do
		local kls = UE_GetObjectClass(v)
		local bl  = UE_InvokeObjectEvent(KismetSystemLibrary,DoesImplementInterface,{{type=szPointer,value=object},{type=szPointer,value=kls}})
		implemented[#implemented+1] = bl[1]==1 and {name=k, Object=v, klass=UE_GetObjectClass(v)} or nil
	  end
	  return implemented
	end

	local function UEForm_lbClassesSelectionChange(sender, user)
	  if sender.ItemIndex == -1 then return end
	  sender = sender and sender or UEForm.lbClasses
	  local items = sender.Items
	  local item = items[sender.ItemIndex]
	  local allOccurances = {}
	  local currentItemIndex = 0
	  for i=0,items.Count-1 do
		if items[i]==item then 
			allOccurances[#allOccurances+1] = i 
			currentItemIndex = i==sender.ItemIndex and #allOccurances or currentItemIndex
		end
 	  end
	  --local bool1 = (UNIQUE_CLASSES[item]) and UNIQUE_CLASSES[item].classAddress and UNIQUE_CLASSES[item].classAddress~=0
	  local bool1 = GetItemByNameFromClasses(UNIQUE_CLASSES,item,currentItemIndex)--(UNIQUE_CLASSES[item]) and UNIQUE_CLASSES[item].classAddress and UNIQUE_CLASSES[item].classAddress~=0
	  clearAllMethodsAndFields(UEForm)
	  if (sender.ItemIndex > -1) and bool1 and bool1.classAddress then
		--print(item,fu(bool1.classAddress),bool1.className,bool1.classOuterName)
		--print('Class Name: -', bool1.className)
		local defObj = GetSpecificObjectByName(bool1.className,"Default__")
		for k,v in pairs(UE_GetAllObjectsOfClass(bool1.className)) do
		    --print(v.name, UE_GetObjectOuterName(v.obj),bool1.classOuterName)
			--print(bool1.classOuterName, ' <-outer')
			if not bool1.classOuterName then defObj = v; break end -- if using old scanner
			if string.find(UE_GetObjectOuterName(v.obj),bool1.classOuterName) then 
				--print(bool1.classOuterName)
				defObj = v; break 
			end
		end
		item = bool1.classOuterName and bool1.classOuterName..'.'..bool1.className or ((defObj and defObj.obj) and UE_GetObjectOuterName(defObj.obj) or "")
		--print(fu(defObj and defObj.obj or 0))
		 local inheritance = UE_GetClassInheritance(bool1.className)
		 InstallInheritance(inheritance)
		 local IsSettings = GHUESettings and GHUESettings.DataCollector
		 if (not IsSettings or GHUESettings.DataCollector.ckbDCShowInterfaces==true) then
		     if defObj and defObj.obj > 0 then
				local bll, interfaces = pcall(function() return GetImplementedInterfaces(defObj.obj) end)
				if not bll then
					LaunchUEDataCollector()
				else
					InstallInterfaces(interfaces)
				end
			 end
		 else
		    UEForm.gbInterfaces.Visible = false;
		 end
		 createThread(function()
		  local fields = {}
		  local functions = {}
		  local bInc = true
		  local bAll = (not IsSettings or GHUESettings.DataCollector.ckbDCShowParentFields==nil) and true or GHUESettings.DataCollector.ckbDCShowParentFields
		  bAll = bAll and 1 or 0
		  
		  if IsSettings then bInc = GHUESettings.DataCollector.ckbDCShowFields end
		  fields = bInc and ((defObj and defObj.obj ~= 0) and UE_GetFieldsOfObject(defObj.obj,bAll) or UE_GetFieldsOfClass(bool1.className,bAll)) or fields
		  bInc = true
		  if IsSettings then bInc = GHUESettings.DataCollector.ckbDCShowFuncs end
		  bAll = (not IsSettings or GHUESettings.DataCollector.ckbDCShowParentFuncs==nil) and true or GHUESettings.DataCollector.ckbDCShowParentFuncs
		  bAll = bAll and 1 or 0
		  functions = bInc and ((defObj and defObj.obj ~= 0) and UE_GetFunctionsOfObject(defObj.obj,bAll) or UE_GetFunctionsOfClass(bool1.className,bAll)) or functions
		  InstallFieldsAndMethods(UEForm,fields,functions,true)
		 end)
		 UEForm.gbClassInformation.Caption=item
	  else print('Error: Class not found in the list')
	  end
	end
	local function UEForm_edtClassFilterChange(sender)
	  local klssTextBox = UEForm.lbClasses
	  if UEForm.btnClassList.Caption == 'Init Class List' then
		 klssTextBox.Items.clear()
		 return
	  end
	  klssTextBox.clear()
	  local arrangedClasses = GetArrangedTable(UNIQUE_CLASSES)
	  local all = sender.Text==""
	  for k,v in pairs(arrangedClasses) do
		  if not(all) and (v:lower():find(sender.Text:lower(),1,true)) then
			 klssTextBox.Items.Add(v)
		  elseif (all) then
			  klssTextBox.Items.Add(v)
		  end
	  end
	end
	local function UEForm_lvMethodsDblClick(sender)
	  if (sender.Selected.Data) and readPointer(sender.Selected.Data) then
		 local str = sender.Selected.SubItems[1]
		 local retType = str:match('.- %(')
		 retType = retType and retType:gsub('%(',''):gsub(' ','') or ""
		 local fields = str:match('%(.*%)')
		 fields = fields and fields:gsub('%(',''):gsub('%)','') or ""
		 --print(retType)print(fields)
		 local syml = getMainSymbolList()
		 local regName = sender.Selected.SubItems[0]..':'..sender.Selected.Caption
		 if not(syml.getSymbolFromString(regName)) then
			syml.addSymbol("UE4",regName,getAddressSafe(sender.Selected.Data),1,false,{returntype="",parameters=""})
		 end
		 getMemoryViewForm().DisassemblerView.SelectedAddress = getAddressSafe(sender.Selected.Data)
		 getMemoryViewForm().show()
	  end
	end
	local function UEForm_ResetBtnClick(sender)
	  clearAllMethodsAndFields(UEForm)
	  while UEForm.gbInheritance.ControlCount>0 do
		UEForm.gbInheritance.Control[0].destroy()
	  end
	  UEForm.btnClassList.Caption= 'Init Class List'
	  UEForm.lblObjCount.Caption = 'Total Objects: '..0
	  UEForm.lblClasses.Caption = 'Total Classes: '..0
	  UEForm.lbClasses.clear()
	  UEForm.scanProgress.Position = 0
	  UEForm.edtClassFilter.Text = ""
	  UEForm.ScanButton.Enabled = true
	end
	local function UEForm_btnLoadAllObjectsClick(sender)
	  --print('clicked')
	  local name = UEForm.lbClasses.Items[UEForm.lbClasses.ItemIndex]--UEForm.gbClassInformation.Caption
	  if not name or name=='' or (name=='Class Information') then return end
	  UEForm.comboFieldBaseAddress.Items.clear()
	  local objects = isKeyPressed(VK_CONTROL) and UE_GetAllSubObjectsOfClass(name) or UE_GetAllObjectsOfClass(name)
	  if #objects > 0 and type(objects[1]) == 'number' then
		for k,v in ipairs(objects) do
			objects[k] = {obj = v, name = UE_GetObjectFullName(v)}
		end
	  end
	  local comboItems = UEForm.comboFieldBaseAddress.Items
	  local altkey = isKeyPressed(VK_MENU)
	  for i=1,#objects do
		 if (readPointer(objects[i].obj)) then
		   if not altkey or not objects[i].name:find('Default__') then
			   local itm = comboItems.Add(fu(objects[i].obj)..'\t'..objects[i].name)
			   comboItems.setData(itm,(objects[i].obj))
		   end
		   --print(UEForm.comboFieldBaseAddress.Items.getData(itm))
		 else
		   printf('%s was a null object.',objects[i].name)
		 end
		 --print(itm,type(itm))
	  end
	end
	local function UEForm_miBrowseFieldClick(sender)
	  local offset = 0
	  local addr = UEForm.comboFieldBaseAddress.Text:match('%x*\t')
	  if not(addr) or addr=="" or not(getAddressSafe(addr)) then return end
	  if UEForm.lvFieldsTree then 
		local f = UEForm.lvFieldsTree
		local nodes = f.enumSelectedNodes()
		if #nodes <=0 then return end
		_node = nodes[1]
		offset = f.OnGetText(f, f.absoluteIndex( _node), 0, _node, nil )
		offset = tonumber(offset,16)
	  else
		offset = UEForm.lvFields.Selected and tonumber(UEForm.lvFields.Selected.Caption,16) or offset
	  end
	  getMemoryViewForm().HexadecimalView.Address = getAddressSafe(addr)+offset
	  getMemoryViewForm().show()
	end
	local function UEForm_miGoToExecFuncClick(sender)
	  UEForm_lvMethodsDblClick(UEForm.lvMethods)
	end
	local function UEForm_miCopyFuncClick(sender)
	 local sel = UEForm.lvMethods.Selected
	 if not(sel) then writeToClipboard(0) return end
	 writeToClipboard(sel.SubItems[2]) --UFunction
	end
	local function UEForm_miCopyClassClick(sender)
	  if (UEForm.lbClasses.ItemIndex==-1) then return end
	  local classes = UEForm.lbClasses
	  local txt = classes.Items[classes.ItemIndex]
	  writeToClipboard(txt)
	  --print(sender.Selected)
	end
	local function UEForm_miCopyFieldDataClick(sender)
	  if UEForm.lvFieldsTree then
		local f = UEForm.lvFieldsTree
		local nodes = f.enumSelectedNodes()
		if #nodes <=0 then return end
		_node = nodes[1]
		writeToClipboard(f.OnGetText(f, f.absoluteIndex( _node), 3, _node, nil ))
	  else
	    if not(UEForm.lvFields.Selected) then return end
		local fields = UEForm.lvFields
		local txt = fields.Selected.Caption..' - '..fields.Selected.SubItems[0]..' - '..fields.Selected.SubItems[1]--..' - '..  ..' - '..
		writeToClipboard(txt)
	  end
	end
	local function UEForm_miCopyFuncNameClick(sender)
	  if not(UEForm.lvMethods.Selected) then return end
	  writeToClipboard(UEForm.lvMethods.Selected.Caption)
	end
	local function UEForm_miCopyFuncClassClick(sender)
	  if not(UEForm.lvMethods.Selected) then return end
	  writeToClipboard(UEForm.lvMethods.Selected.SubItems[0])
	end
	local function UEForm_miCopyParamsClick(sender)
	  if not(UEForm.lvMethods.Selected) then return end
	  writeToClipboard(UEForm.lvMethods.Selected.SubItems[1])
	end
	local function UEForm_miClassFindClick(sender)
		FindInListBox(UEForm.lbClasses)
		print(UEForm.lbClasses.Name)
	end
	local function UEForm_miFieldsFindClick(sender)
		FindInListBox(UEForm.lvFields)
	end
	local function UEForm_miFunctionFindClick(sender)
		FindInListBox(UEForm.slvMethods)
	end
	--[[local function UEForm_miPrintParamFormatClick(sender)

	end--]]
	
	UEForm.ScanButton.OnClick = function(sender)
	   UEForm_ScanButtonClick(sender)
	end
	UEForm.btnClassList.OnClick = function(sender)
	   UEForm_btnClassListClick(sender)
	end
	UEForm.ResetBtn.OnClick = function(sender)
	   UEForm_ResetBtnClick(sender)
	end
	UEForm.btnLoadAllObjects.OnClick = function(sender)
	   UEForm_btnLoadAllObjectsClick(sender)
	end
	UEForm.lbClasses.OnSelectionChange = function(sender,user)
	   LaunchUEDataCollector()
	   InitUE()
	   --createThread(function() 
		UEForm_lbClassesSelectionChange(sender,user)
	   --end)
	end
	UEForm.edtClassFilter.OnChange = function(sender)
	   UEForm_edtClassFilterChange(sender)
	end
	UEForm.lvMethods.OnDblClick = function(sender)
	   UEForm_lvMethodsDblClick(sender)
	end
	UEForm.miBrowseField.OnClick = function(sender)
	   UEForm_miBrowseFieldClick(sender)
	end
	UEForm.miGoToExecFunc.OnClick = function(sender)
	   UEForm_miGoToExecFuncClick(sender)
	end
	UEForm.btnDumpObjects.OnClick = function(sender)
	  local bDumpFProp = (GHUESettings and GHUESettings.Dumping) and (GHUESettings.Dumping.ckbDMPFProp and 1 or 0) or 1
	  local bDumpUDE   = (GHUESettings and GHUESettings.Dumping) and (GHUESettings.Dumping.ckbDMPUserDefinedEnums and 1 or 0) or 1
	  UE_DumpObjects(bDumpFProp,bDumpUDE)
	  --print('Object Successfully Dumped')
	end
	UEForm.lblAbout.OnMouseEnter = function(sender)
	  sender.Color = clSkyBlue
	end
	UEForm.lblAbout.OnMouseLeave = function(sender)
	  sender.Color = clDefault
	end
	UEForm.lblAbout.OnMouseDown = function(sender)
	  shellExecute('https://guidedhacking.com/resources/guided-hacking-unreal-engine-dumper-cheat-engine-plugin.763/')
	end
	UEForm.ghLogo.OnClick = function(sender)
	 shellExecute('https://guidedhacking.com/')
	end
	UEForm.miCopyFunc.OnClick = function(sender)
		UEForm_miCopyFuncClick(sender)
	end
	UEForm.miCopyClass.OnClick = function(sender)
		UEForm_miCopyClassClick(sender)
	end
	UEForm.miCopyFieldData.OnClick = function(sender)
		UEForm_miCopyFieldDataClick(sender)
	end
	UEForm.miCopyFuncName.OnClick = function(sender)
		UEForm_miCopyFuncNameClick(sender)
	end
	UEForm.miCopyFuncClass.OnClick = function(sender)
		UEForm_miCopyFuncClassClick(sender)
	end
	UEForm.miCopyParams.OnClick = function(sender)
		UEForm_miCopyParamsClick(sender)
	end
	UEForm.miDecompileFunction.OnClick = function(sender)
		if (UE_GetDecompilerState()=='Working') then
			showMessage('Decompiler state','Decompiler is already working, cannot start another decompilation')
			return
		end
		local sel = UEForm.lvMethods.Selected
		if not(sel) then showMessage('Error: Nil Selection') return end
		local adr = getAddress(sel.SubItems[2]) --UFunction
		local c = UE_CheckAddressAsObject(adr)
		if c==0 or c~=adr then showMessage('Error: Not valid UObject') return end
		local dta = UE_GetFunctionFlagNames(UE_GetFunctionData(adr).FunctionFlags)
		local bisuber = false
		for k,v in pairs(dta) do
			if v=='FUNC_UbergraphFunction' then bisuber = true end
		end
		local kls = UE_GetObjectName(UE_GetObjectOuter(adr))
		local obj = UE_GetObjectName(adr)
		local t = GetPrmsForDecompiler()
		if bisuber then
			--print('UbergraphFunction')
			local entrypoint = inputQuery('Entry point for Ubergraph',('Current function "%s" requires an entry point:'):format(obj),1)
			entrypoint = tonumber(entrypoint)
			if not entrypoint or entrypoint==0 then showMessage('Error: Entry point can never be NULL') return end
			UE_DecompileScript(kls, obj, UEScriptDecompileTypes.Ubergraph, entrypoint, t.bubf, t.scnd, t.owcl, t.lcpr, t.inpr, t.dfpr, t.prtp, t.ennm, t.bcin)
		else
			UE_DecompileScript(kls, obj, UEScriptDecompileTypes.SpecificFunction, nil, t.bubf, t.scnd, t.owcl, t.lcpr, t.inpr, t.dfpr, t.prtp, t.ennm, t.bcin)
		end			
	end
	UEForm.btnDumpNames.OnClick = function(sender)
		UE_DumpNames()
	end
	UEForm.miClassFind.OnClick = function(sender) 
		--UEForm_miClassFindClick(sender)
		FindInListBox(UEForm.lbClasses)
	end
	UEForm.miFieldsFind.OnClick = function(sender) 
		--UEForm_miFieldsFindClick(sender)
		FindInListView(UEForm.lvFields)
	end
	UEForm.miFunctionFind.OnClick = function(sender) 
		--UEForm_miFunctionFindClick(sender)
		FindInListView(UEForm.lvMethods)
	end
	UEForm.miPrintParamFormat.OnClick = function(sender)
		local sel = UEForm.lvMethods.Selected
		if not sel then print('Invalid Selection') return end
		local str = ("0x%s"):format(sel.SubItems[2])
		local adr = getAddressSafe(str)
		if not adr then print('Failed to get valid address') return end
		PrintFunParmInInvokeFormat(adr)
	end
	--CE 7.5+
	if not UEForm.lvFieldsTree and createVirtualStringTree and bAllowNodesInFieldView then
	  --if UEForm.lvFieldsTree then UEForm.lvFieldsTree.destroy() UEForm.lvFieldsTree=nil end
	  UEForm.lvFieldsTree = createVirtualStringTree(UEForm.lvFields.Parent)
	  UEForm.lvFieldsTree.Name = "lvFieldsTree"
	  local flt = UEForm.lvFieldsTree
	  flt.Header.Columns.clear()
	  local clOffset=flt.Header.Columns.add('Offset')
	  local clName=flt.Header.Columns.add('Name')
	  local clType=flt.Header.Columns.add('Type')
	  UEForm.lvFieldsTree.PopupMenu = UEForm.lvFields.PopupMenu
	  UEForm.lvFieldsTree.FullRowSelect = true

	  UEForm.lvFieldsTree.OnGetText=function(sender, nodeindex, columnindex, node, texttype)
		local field = getRef(UEForm.lvFieldsTree.getNodeDataAsInteger(node))
		if not field or type(field)~='table' then return 'ERROR: field was nil' end
		
		if (columnindex==0) then --Offset
		   return string.format("%.3X", field.offset)
		elseif (columnindex==1) then --Name
		   local name = field.name
			if (field.FieldMask~=-1) then
			   name = name..'['..field.FieldMask..']'
			end
		   return name
		elseif (columnindex==2) then --Type
			local objName = field.class
			if     (field.class == "ObjectProperty") or (field.class == "ClassProperty") or (field.class == "StructProperty") then
				objName = objName..'('..field.SpecialName..')'
			elseif (field.class == "ByteProperty") or (field.class == "EnumProperty") then
				local sp = field.SpecialName =="" and "" or '('..field.SpecialName..')'
				objName = objName..sp
			elseif ((field.class=="ArrayProperty" or field.class=="SetProperty") and #field.SubFields > 0) then
				local kls = field.SubFields[1].class:gsub('Property','')
				local spn = field.SubFields[1].SpecialName
				local inName = spn=="" and kls or kls..'('..spn..')'
				objName = objName..'<'..inName..'>'
			elseif (field.class=="MapProperty" and #field.SubFields == 2) then
				local kls = field.SubFields[1].class:gsub('Property','')
				local spn = field.SubFields[1].SpecialName
				local inName = spn=="" and kls or kls..'('..spn..')'
				kls = field.SubFields[2].class:gsub('Property','')
				spn = field.SubFields[2].SpecialName
				local inName2 = spn=="" and kls or kls..'('..spn..')'
				objName = objName..'<'..inName..','..inName2..'>'
			end
		   return objName
		else
		   return ('%.3x: %s - %s'):format(field.offset, field.class, field.name)
		end
	  end
	  UEForm.lvFieldsTree.OnExpanding=function(sender, node)
		  local field=getRef(sender.getNodeDataAsInteger(node))
		  --if (field.class~='ObjectProperty') then return false end
		  --print(field.name, field.SpecialName)
		  if not field or not(field.class=='ObjectProperty' or field.class=='StructProperty') or not field.SpecialName or field.SpecialName == '' then print("Property Should Have Been either UObject or UStruct") return end
		  if sender.getFirstChild(node) ~= nil then return true end
		  local subFields = field.class=='ObjectProperty' and UE_GetFieldsOfClass(field.SpecialName,1) or field.SubFields
			local b = GHUESettings and GHUESettings.DataCollector and GHUESettings.DataCollector.ckbDCExpandStructs~=nil
			b = not(b) and true or GHUESettings.DataCollector.ckbDCExpandStructs
		  table.sort(subFields, function(a, b)
						  if (a.offset == b.offset) then
							 return a.FieldMask < b.FieldMask
						  end
						  return a.offset < b.offset
						 end)
		  local function AddItem(v)
			  if (b and v.class == 'StructProperty' and #v.SubFields>0) then
				for i=1,#v.SubFields do
				    v.SubFields[i].name = v.SpecialName~='' and '('..v.SpecialName..') '..v.SubFields[i].name or v.SubFields[i].name
					AddItem(v.SubFields[i])
				end
			  else
				  local newnode=sender.addChild(node)
				  sender.setNodeDataAsInteger(newnode, createRef(v))
				  if (v.class == "ObjectProperty") or (v.class == "StructProperty") then
					sender.HasChildren[newnode]=true
				  end
			  end
		  end
		  for k,v in pairs(subFields) do
			 AddItem(v)
		  end
		  return true;
		  --print(field.SpecialName)
	  end

	  UEForm.lvFieldsTree.OnFreeNode=function(sender,node)
		local d=sender.getNodeDataAsInteger(node)
		destroyRef(d)
	  end


	  UEForm.lvFieldsTree.align=alClient
	  UEForm.lvFields.align=alBottom
	  UEForm.lvFields.visible=false

	  --cValue.Visible=false
	  UEForm.lvFieldsTree.Header.AutoResize=true
	  UEForm.lvFieldsTree.Header.AutoSizeIndex=2
	  
	  clOffset.Width=UEForm.lvFields.Columns[0].Width
	  clName.Width=UEForm.lvFields.Columns[1].Width
	  clType.Width=UEForm.lvFields.Columns[2].Width
	end

end


