begin level_set_topology
    background_mesh_name lbracket3d.exo
    output_mesh_name level-set-result.exo
    include_void_region true
    sphere_pattern_bbox_min_x -.5
    sphere_pattern_bbox_min_y -.5
    sphere_pattern_bbox_min_z 0
    sphere_pattern_bbox_max_x .4
    sphere_pattern_bbox_max_y .4
    sphere_pattern_bbox_max_z 0
    sphere_pattern_radius .05
    sphere_pattern_spacing .15
    level_set_lower_bound -.02
    level_set_upper_bound .02
end

begin kernel_filter
    filter_radius 0.05
    centering_type node
end

begin constraint volume
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear false
    constraint_type equal_to
    constraint_value 0.0
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0e6
end

begin rol_optimization
    input_file_name rol_inputs_AL.xml
    output_design_history true
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.5
    random_direction_seed 123
end
