# Tests that a mesh with two blocks gives identical results to a mesh
# with a single block.

begin density_topology
    mesh_name lbracket-two-block.exo
    output_name to-result.exo
    initial_density_value 0.5
end

begin helmholtz_filter
    filter_radius 8.660254038e-2
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol_2_block.xml
    is_linear true
    constraint_value 0.32
    constraint_type equal_to
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to_2_block.xml
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 5
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
end
