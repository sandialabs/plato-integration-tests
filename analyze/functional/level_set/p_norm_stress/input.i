begin level_set_topology
    background_mesh_name lbracket3d.exo
    output_mesh_name level-set-result.exo
    include_void_region true
    sphere_pattern_bbox_min_x -.25
    sphere_pattern_bbox_min_y -.5
    sphere_pattern_bbox_min_z -1
    sphere_pattern_bbox_max_x .5
    sphere_pattern_bbox_max_y .5
    sphere_pattern_bbox_max_z 1
    sphere_pattern_radius .1
    sphere_pattern_spacing .25
    level_set_lower_bound -.02
    level_set_upper_bound .02
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin objective p_norm
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_p_norm.xml
    aggregation_weight 1.0  
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 150
    initial_direction_magnitude 10
    step_size_reduction_factor 0.9
    random_direction_seed 1
end
