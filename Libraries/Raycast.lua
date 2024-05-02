local function streets_raycast(Start: Vector3, End: Vector3, Distance: number, Blacklist: table): tuple
    return workspace:FindPartOnRayWithIgnoreList(Ray.new(Start, CFrame.new(Start, End).LookVector * Distance), Blacklist)
end


local function Raycast(Position: Vector3, Position_2: Vector3, Blacklist: table)
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Blacklist
    RayParams.FilterDescendantsInstances = Blacklist

    return workspace:Raycast(Position, Position_2, RayParams)
end


return {
    new = Raycast,
    streets = streets_raycast
}