begin level_set_topology
    background_mesh_name plate.exo
    output_mesh_name level-set-result.exo
    include_void_region true
    sphere_pattern_bbox_min_x -4.5
    sphere_pattern_bbox_min_y -4.5
    sphere_pattern_bbox_min_z -2
    sphere_pattern_bbox_max_x 5
    sphere_pattern_bbox_max_y 5
    sphere_pattern_bbox_max_z 1
    sphere_pattern_radius 1.5
    sphere_pattern_spacing 4
    level_set_lower_bound -1
    level_set_upper_bound 1
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin objective mass_properties
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass_properties.xml
    aggregation_weight 1000
end

begin rol_optimization
    max_iterations 3
    approximate_hessian true
    initial_search_radius 200
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 9
    initial_direction_magnitude 20
    step_size_reduction_factor 0.5
    random_direction_seed 123
end
