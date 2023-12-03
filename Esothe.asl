state("Esothe-Win64-Shipping")
{
    int orbcountptr : 0x02BC6660, 0xDC0, 0x220;
    int mainmenu    : 0x2B9E250;
}

startup
{
    //creates text components for variable information
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
	        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
	        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
	        if (textSetting == null)
	        {
	        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
	        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
	        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
	
	        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
	        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
	        }
	
	        if (textSetting != null)
	        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    //Parent setting
	settings.Add("Variable Information", true, "Variable Information");
	//Child settings that will sit beneath Parent setting
    settings.Add("Orb Count", true, "Current Orb Count", "Variable Information");
}

update
{
    if(settings["Orb Count"]) 
    {
        vars.SetTextComponent("Orbs In Inventory:",current.orbcountptr.ToString());
    }

//DEBUG CODE
    //print("isLoading? " + current.loading.ToString());
    print("Orbs: " + current.orbcountptr.ToString());
    //print(modules.First().ModuleMemorySize.ToString());
}

start
{
    return old.mainmenu == 0 && current.mainmenu != 0;
}

split
{
    return current.orbcountptr > old.orbcountptr || old.orbcountptr == 1 && current.orbcountptr == 0;
}