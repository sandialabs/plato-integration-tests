begin level_set_topology
    mesh_name cylinder.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_pattern_bbox_min_x -10
    sphere_pattern_bbox_min_y -10
    sphere_pattern_bbox_min_z -1
    sphere_pattern_bbox_max_x 10
    sphere_pattern_bbox_max_y 10
    sphere_pattern_bbox_max_z 1
    sphere_pattern_radius 2.5
    sphere_pattern_spacing 5
    level_set_lower_bound -1
    level_set_upper_bound 1
    fixed_blocks fixed_block
end

begin kernel_filter
    filter_radius 2
    use_relative_radius true
    centering_type node
end

begin objective thermal_compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_thermal_compliance.xml
    aggregation_weight 1e-6 
end

begin objective volume_obj
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    aggregation_weight 1 
end

begin rol_optimization
    max_iterations 5
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 8
    initial_direction_magnitude 10
    step_size_reduction_factor 0.5
    random_direction_seed 1
end
