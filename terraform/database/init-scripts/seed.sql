INSERT INTO products (id, name, price) VALUES
                                           (1, 'Laptop', 1200.00),
                                           (2, 'Smartphone', 800.00),
                                           (3, 'Headphones', 150.00),
                                           (4, 'Monitor', 300.00),
                                           (5, 'Keyboard', 100.00)
    ON CONFLICT (id) DO NOTHING;
