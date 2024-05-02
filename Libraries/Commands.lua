local Commands = {}


function Commands.Add(Name, Aliases, Description, Function)
    local Command = {}
    Command.Name = Name
    Command.Aliases = Aliases or {}
    Command.Description = Description or ""
    Command.Run = Function

    table.insert(Commands, Command)
    return Command
end


function Commands.Remove(Name)
    local __Name = string.lower(Name)
    for Index, Command in ipairs(Commands) do
        local Command_Name = Command.Name
        if string.lower(Command_Name) == __Name then
            return table.remove(Commands, Index)
        end
    end
    return false
end

        
function Commands.Check(Name, Prefix)
    local Arguments = string.split(Name, " ")
    local __Name = string.lower(table.remove(Arguments, 1))
    Prefix = Prefix or ""

    for _, Command in ipairs(Commands) do
        local Command_Name = Command.Name
        if (Prefix .. string.lower(Command_Name)) == __Name then
            Command.Run(Arguments)
            return Command_Name
        end

        for _, Alias in ipairs(Command.Aliases) do
            if (Prefix .. string.lower(Alias)) == __Name then
                Command.Run(Arguments)
                return Command_Name
            end
        end
    end

    return false
end
    
return Commands
