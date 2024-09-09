state("Amber-Win64-Shipping")
{
    sbyte Starter: 0x6B5F4B8, 0x90, 0x18, 0x924;
    sbyte Credits: 0x6F946C0, 0x208;
    double megacorn: 0x6C1E850, 0x6A0, 0x90, 0x58, 0x330, 0x2E0, 0x98
}

start
{
    return old.Starter == 64 && current.Starter == 80;
}

isLoading
{

}

split
{

}