begin density_topology
    mesh_name window.exo
    output_name to-result.exo
    initial_density_value 0.5
end

begin kernel_filter
    centering_type element
    filter_radius 2.0
    use_relative_radius true
end

begin objective strain_energy
    app plato-python-app
    criterion plato-python-app
    input_files plato-python-app-input.xml
    aggregation_weight 1.0
    objective_type minimize
end

begin rol_optimization
    max_iterations 5
end
