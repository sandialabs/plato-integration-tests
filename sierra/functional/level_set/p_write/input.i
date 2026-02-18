begin level_set_topology
    mesh_name shelf_wedge.exo
    output_name result-wedge.exo
    include_void_region false
    sphere_list radius 3 center (0,0,1.2),
                radius 3 center (4,4,1.2)
    level_set_bounds [-0.6,0.6]
    #max_edge_length_percentage_for_snapping 0
    fixed_blocks fixed_block 
end

begin wedge_filter
    target_mesh_name shelf.exo
    filter_radius 1.2
    use_relative_radius true
    centering_type node
    wedge_angle 45
    fixed_blocks fixed_block
end

begin objective mass_one
    app sierra_sd
    active true
    criterion mass
    number_of_processors 1
    input_files mass.i
    aggregation_weight 1.0e-3
    objective_goal minimize
end

begin objective mass_two
    app sierra_sd
    active true
    criterion mass
    number_of_processors 1
    input_files mass.i
    aggregation_weight 1.0e-3
    objective_goal minimize
end

begin rol_optimization 
    max_iterations 2
end
