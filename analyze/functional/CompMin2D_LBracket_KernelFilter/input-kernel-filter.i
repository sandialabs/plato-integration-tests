begin density_topology
    mesh_name lbracket.exo
    output_name to-result.exo
    initial_density_value 0.5
end

begin kernel_filter
    filter_radius 2.5e-2
    centering_type node
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol.xml
    is_linear true
    constraint_value 0.32
    constraint_type equal_to
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to.xml
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 5
end
