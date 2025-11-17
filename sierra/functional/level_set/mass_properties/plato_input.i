begin level_set_topology
    mesh_name background.exo
    output_name result.exo
    include_void_region false
    sphere_pattern_bbox_min_x 0
    sphere_pattern_bbox_min_y 0
    sphere_pattern_bbox_min_z 0
    sphere_pattern_bbox_max_x 0
    sphere_pattern_bbox_max_y 0
    sphere_pattern_bbox_max_z 0
    sphere_pattern_radius 1.25
    sphere_pattern_spacing 2
    level_set_lower_bound -0.2
    level_set_upper_bound  0.2
end

begin kernel_filter
    filter_radius 0.7
    centering_type node
end

begin constraint cg
    app sierra_sd
    criterion center-of-gravity
    input_files salinas_input.i
    constraint_value_list component cg_x target 6.0,
                          component cg_y target 8.5,
                          component cg_z target 10.0

    constraint_type equal_to
    is_linear false
end

begin objective mass
    app sierra_sd
    criterion mass
    number_of_processors 2
    input_files salinas_input.i
    aggregation_weight 1.0
end

begin constraint_check
    linearity_check_output_file_name constraint_linearity_check.txt
    jacobian_check_output_file_name constraint_jacobian_check.txt
    jacobian_adjoint_consistency_output_file_name constraint_jacobian_adjoint_consistency_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
end

begin gradient_check
    output_file_name gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.5
    random_direction_seed 42
end

