begin level_set_topology
    mesh_name lbracket3d.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 0.15 center (0,-0.3,0)
    level_set_bounds [-1, 1]
    max_edge_length_percentage_for_snapping 0
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
    aggregation_weight 1.0e-4
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
