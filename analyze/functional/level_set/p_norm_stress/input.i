begin level_set_topology
    mesh_name lbracket3d.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_pattern radius 0.1 spacing 0.25 min (-0.25,-0.5,-1) max (0.5,0.5,1)
    level_set_bounds [-0.02, 0.02]
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
