state("Fusion", "3.64")
{
  byte starting: "Fusion.exe", 0x2A52D4, 0xF601;
  byte level: "Fusion.exe", 0x2A52D4, 0xF607;
}
state("emuhawk", "2.9.1")
{
  byte starting: "libgenplusgx.dll", 0x000062D8, 0xF601;
  byte level: "libgenplusgx.dll", 0x000062D8, 0xF607;
}
start
{
  return (current.starting == 0x10 && current.level == 0x1);
}
split
{
  if (current.level != old.level) return true;
}
reset
{
  if (current.level == 0x0 && current.starting != 0x10) return true;
}
