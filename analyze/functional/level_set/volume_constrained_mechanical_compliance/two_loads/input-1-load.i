begin level_set_topology
    mesh_name lbracket3d.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_pattern radius 0.05 spacing 0.15 min (-0.5,-0.5,0) max (0.4,0.4,0)
    level_set_bounds [-0.02, 0.02]
end

begin kernel_filter
    filter_radius 0.05
    centering_type node
end

begin objective compliance_1
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0e6
end

begin gradient_check
    output_file_name ROL_gradient_check_output_1_load.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.5
    random_direction_seed 123
    direction_vector_type random
end
