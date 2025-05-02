begin level_set_topology
    mesh_name window_bg.exo
    output_name level-set-result.exo
    include_void_region false
    sphere_pattern_bbox_min_x -0.5
    sphere_pattern_bbox_min_y -0.5
    sphere_pattern_bbox_min_z -0.5
    sphere_pattern_bbox_max_x 0.5
    sphere_pattern_bbox_max_y 0.5
    sphere_pattern_bbox_max_z 0.5
    sphere_pattern_radius .35
    sphere_pattern_spacing 2.0
    level_set_lower_bound -1.0
    level_set_upper_bound 1.0
end

begin kernel_filter
    centering_type node
    filter_radius 2.0
    use_relative_radius true
end

begin objective strain_energy
    app plato-python-app
    criterion plato-python-app
    input_files plato-python-app-input.xml
    aggregation_weight 1.0
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1 
    step_size_reduction_factor 0.1
    random_direction_seed 12
end

begin rol_optimization
    max_iterations 5
    output_design_history true
end
