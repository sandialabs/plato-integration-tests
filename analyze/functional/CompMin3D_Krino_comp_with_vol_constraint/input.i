begin levelset_topology
    background_mesh_name unit_cube_background.exo
    cut_mesh_name cut_mesh.exo
    output_mesh_name krino-result.exo
    include_void_region false
    sphere_pattern_bbox_min_x 0
    sphere_pattern_bbox_min_y 0
    sphere_pattern_bbox_min_z 0
    sphere_pattern_bbox_max_x 1
    sphere_pattern_bbox_max_y 1
    sphere_pattern_bbox_max_z 1
    sphere_pattern_radius .25
    sphere_pattern_spacing 2
    levelset_lower_bound -.2
    levelset_upper_bound .2
end

begin constraint volume
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol.xml
    is_linear false
    constraint_type equal_to
    constraint_value 0.9
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0
    objective_type minimize
end

begin rol_optimization
    input_file_name rol_inputs_AL.xml
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 12
    initial_direction_magnitude 1 
    step_size_reduction_factor 0.1
    random_direction_seed 1
end
