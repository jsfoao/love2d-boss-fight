Type_registry = {
    world_id = 0,
    entity_id = 0,
    component_id = 0,
    components = {},
    entities = {}
}

function Type_registry.create_component_type(type_name)
    local _comp_type = { type_id = Type_registry.component_id, name = type_name }
    Type_registry.component_id = Type_registry.component_id + 1
    Type_registry.components[#Type_registry.components+1] = _comp_type
    return _comp_type
end

function Type_registry.create_entity_type(type_name)
    local _entity_type = { type_id = Type_registry.entity_id, name = type_name }
    Type_registry.entity_id = Type_registry.entity_id + 1
    Type_registry.entities[#Type_registry.components+1] = _entity_type
    return _entity_type
end

function Type_registry.is_valid_component(type_name)
    for key, component_type in pairs(Type_registry.components) do
        if type_name.type_id == component_type.type_id then
            return true
        end
    end
    return false
end

function Type_registry.is_valid_entity(type)
    for key, entity_type in pairs(Type_registry.entities) do
        if type.type_id == entity_type.type_id then
            return true
        end
    end
    return false
end

return Type_registry