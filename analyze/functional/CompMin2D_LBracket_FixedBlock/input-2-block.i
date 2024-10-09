begin density_topology
    mesh_name lbracket-two-block.exo
    output_name to-result.exo
    fixed_blocks block_1
    initial_density_value 0.5
end

begin helmholtz_filter
    filter_radius 2.5e-2
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol_2_block.xml
    is_linear true
    equal_to 0.5
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to_2_block.xml
    aggregation_weight 1.0
    objective_type minimize
end

begin rol_optimization
    input_file_name rol_inputs.xml
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
end
