-- <Migration ID="678c0282-fb50-4272-aec4-a8522dc40927" />
GO


SET DATEFORMAT YMD;


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[Categories]) = 0
    BEGIN
        PRINT (N'Add 5 rows to [dbo].[Categories]');
        SET IDENTITY_INSERT [dbo].[Categories] ON;
        INSERT  INTO [dbo].[Categories] ([CategoryId], [Description], [ImageUrl], [Name])
        VALUES                         (1, N'Brakes description', N'product_brakes_disc.jpg', N'Brakes');
        INSERT  INTO [dbo].[Categories] ([CategoryId], [Description], [ImageUrl], [Name])
        VALUES                         (2, N'Lighting description', N'product_lighting_headlight.jpg', N'Lighting');
        INSERT  INTO [dbo].[Categories] ([CategoryId], [Description], [ImageUrl], [Name])
        VALUES                         (3, N'Wheels & Tires description', N'product_wheel_rim.jpg', N'Wheels & Tires');
        INSERT  INTO [dbo].[Categories] ([CategoryId], [Description], [ImageUrl], [Name])
        VALUES                         (4, N'Batteries description', N'product_batteries_basic-battery.jpg', N'Batteries');
        INSERT  INTO [dbo].[Categories] ([CategoryId], [Description], [ImageUrl], [Name])
        VALUES                         (5, N'Oil description', N'product_oil_premium-oil.jpg', N'Oil');
        SET IDENTITY_INSERT [dbo].[Categories] OFF;
    END


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[Stores]) = 0
    BEGIN
        PRINT (N'Add 20 rows to [dbo].[Stores]');
        SET IDENTITY_INSERT [dbo].[Stores] ON;
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (1, N'Store1');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (2, N'Store18');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (3, N'Store17');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (4, N'Store16');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (5, N'Store15');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (6, N'Store14');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (7, N'Store13');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (8, N'Store12');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (9, N'Store11');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (10, N'Store10');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (11, N'Store9');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (12, N'Store8');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (13, N'Store7');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (14, N'Store6');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (15, N'Store5');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (16, N'Store4');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (17, N'Store3');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (18, N'Store2');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (19, N'Store19');
        INSERT  INTO [dbo].[Stores] ([StoreId], [Name])
        VALUES                     (20, N'Store20');
        SET IDENTITY_INSERT [dbo].[Stores] OFF;
    END


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[Products]) = 0
    BEGIN
        PRINT (N'Add 18 rows to [dbo].[Products]');
        SET IDENTITY_INSERT [dbo].[Products] ON;
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (1, 2, '2018-05-03 11:13:53.1574600', N'Our Halogen Headlights are made to fit majority of vehicles with our  universal fitting mold. Product requires some assembly.', 10, 0, 38.99, N'product_lighting_headlight.jpg', N'{ "Light Source" : "Halogen", "Assembly Required": "Yes", "Color" : "Clear", "Interior" : "Chrome", "Beam": "low and high", "Wiring harness included" : "Yes", "Bulbs Included" : "No",  "Includes Parking Signal" : "Yes"}', 1, 38.99, N'LIG-0001', N'Halogen Headlights (2 Pack)');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (2, 5, '2018-05-03 11:13:53.1591537', N'Ensure that your vehicle''s engine has a longer life with our new filter set. Trapping more dirt to ensure old freely circulates through your engine.', 3, 0, 28.99, N'product_oil_filters.jpg', N'{ "Filter Type" : "Canister and Cartridge", "Thread Size" : "0.75-16 in.", "Anti-Drainback Valve" : "Yes"}', 16, 28.99, N'OIL-0001', N'Filter Set');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (3, 4, '2018-05-03 11:13:53.1591533', N'Battery Jumper Leads have a built in surge protector and a includes a plastic carry case to keep them safe from corrosion.', 6, 0, 16.99, N'product_batteries_jumper-leads.jpg', N'{ "length" : "6ft.", "Connection Type" : "Alligator Clips", "Fit" : "Universal", "Max Amp''s" : "750" }', 15, 16.99, N'BAT-0003', N'Jumper Leads');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (4, 4, '2018-05-03 11:13:53.1591529', N'Spiral Coil batteries are the preferred option for high performance Vehicles where extra toque is need for starting. They are more resistant to heat and higher charge rates than conventional batteries.', 3, 0, 154.99, N'product_batteries_premium-battery.jpg', N'{ "Type": "Spiral Coil", "Volts" : "12", "Weight" : "20.3 lbs", "Size" :  "7.4x5.1x8.5", "Cold Cranking Amps" : "460" }', 14, 154.99, N'BAT-0002', N'Spiral Coil Battery');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (5, 4, '2018-05-03 11:13:53.1591525', N'Calcium is the most common battery type. It is durable and has a long shelf and service life. They also provide high cold cranking amps.', 9, 0, 129.99, N'product_batteries_basic-battery.jpg', N'{ "Type": "Calcium", "Volts" : "12", "Weight" : "22.9 lbs", "Size" :  "7.7x5x8.6", "Cold Cranking Amps" : "510" }', 13, 129.99, N'BAT-0001', N'12-Volt Calcium Battery');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (6, 1, '2018-05-03 11:13:53.1591521', N'Upgrading your brakes can increase stopping power, reduce dust and noise. Our Disk Calipers exceed factory specification for the best performance.', 2, 0, 43.99, N'product_brakes_disc-calipers-red.jpg', N'{"Disk Design" : "Cross Drill Slotted", " Pad Material" : "Carbon Ceramic",  "Construction" : "Vented Rotor", "Diameter" : "11.3 in.", "Bolt Pattern": "6 x 5.31 in.", "Finish" : "Silver Zinc Plated",  "Material" : "Carbon Alloy", "Includes Brake Pads" : "Yes" }', 12, 43.99, N'BRA-0003', N'Brake Disk and Calipers');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (7, 1, '2018-05-03 11:13:53.1591516', N'Our Brake Rotor Performs well in wet coditions with a smooth responsive feel. Machined to a high tolerance to ensure all of our Brake Rotors are safe and reliable.', 4, 0, 18.99, N'product_brakes_disc.jpg', N'{ "Disk Design" : "Cross Drill Slotted",  "Construction" : "Vented Rotor", "Diameter" : "10.3 in.", "Finish" : "Silver Zinc Plated", "Hat Finish" : "Black E-coating",  "Material" : "Cast Iron" }', 11, 18.99, N'BRA-0002', N'Brake Rotor');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (8, 3, '2018-05-03 11:13:53.1591512', N'Our brake disks and pads perform the best togeather. Better stopping distances without locking up, reduced rust and dusk.', 0, 6, 25.99, N'product_brakes_disk-pad-combo.jpg', N'{ "Disk Design" : "Cross Drill Slotted", " Pad Material" : "Ceramic", "Construction" : "Vented Rotor", "Diameter" : "10.3 in.", "Finish" : "Silver Zinc Plated", "Hat Finish" : "Silver Zinc Plated", "Material" : "Cast Iron" }', 10, 25.99, N'BRA-0001', N'Disk and Pad Combo');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (9, 3, '2018-05-03 11:13:53.1591508', N'Having trouble in the wet? Then try our special patent tire on a heavy duty steel rim. These wheels perform excellent in all conditions but were designed specifically for wet weather.', 3, 0, 219.99, N'product_wheel_tyre-wheel-combo-pack.jpg', N'{ "Material" : "Steel",  "Design" : "Spoke", "Spokes" : "8",  "Number of Lugs" : "5", "Wheel Diameter" : "19 in.", "Color" : "Gray", "Finish" : "Standard", "Pre-Assembled" : "Yes" } ', 9, 219.99, N'WHE-0006', N'Wheel Tire Combo (4 Pack)');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (10, 3, '2018-05-03 11:13:53.1591504', N'Save time and money with our ever popular wheel and tire combo. Pre-assembled and ready to go.', 1, 0, 129.99, N'product_wheel_tyre-rim-chrome-combo.jpg', N'{ "Material" : "Aluminum alloy",  "Design" : "Spoke", "Spokes" : "10",  "Number of Lugs" : "5", "Wheel Diameter" : "17 in.", "Color" : "Silver", "Finish" : "Chrome", "Pre-Assembled" : "Yes" } ', 8, 129.99, N'WHE-0005', N'Chrome Rim Tire Combo');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (11, 3, '2018-05-03 11:13:53.1591500', N'For the endurance driver, take advantage of our best wearing tire yet. Composite rubber and a heavy duty steel rim.', 0, 4, 72.49, N'product_wheel_tyre-wheel-combo.jpg', N'{ "Material" : "Steel",  "Design" : "Spoke", "Spokes" : "8",  "Number of Lugs" : "4", "Wheel Diameter" : "19 in.", "Color" : "Gray", "Finish" : "Standard", "Pre-Assembled" : "Yes" } ', 7, 72.49, N'WHE-0004', N'Wheel Tire Combo');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (12, 3, '2018-05-03 11:13:53.1591496', N'Light Weight Rims with a twin cross spoke design for stability and reliable performance.', 3, 0, 99.99, N'product_wheel_rim-red.jpg', N'{ "Material" : "Aluminum alloy",  "Design" : "Spoke", "Spokes" : "12",  "Number of Lugs" : "5", "Wheel Diameter" : "18 in.", "Color" : "Red", "Finish" : "Matte" } ', 6, 99.49, N'WHE-0003', N'High Performance Rim');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (13, 3, '2018-05-03 11:13:53.1591480', N'Stand out from the crowd with a set of aftermarket blue rims to make you vehicle turn heads and at a price that will do the same.', 8, 0, 88.99, N'product_wheel_rim-blue.jpg', N'{ "Material" : "Aluminum alloy",  "Design" : "Spoke", "Spokes" : "5",  "Number of Lugs" : "4", "Wheel Diameter" : "18 in.", "Color" : "Blue", "Finish" : "Glossy" } ', 5, 88.99, N'WHE-0002', N'Blue Performance Alloy Rim');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (14, 3, '2018-05-03 11:13:53.1591393', N'A Parts Unlimited favorite, the Matte Finish Rim is affordable low profile style. Fits all low profile tires.', 4, 0, 75.99, N'product_wheel_rim.jpg', N'{ "Material" : "Aluminum alloy",  "Design" : "Spoke", "Spokes" : "9",  "Number of Lugs" : "4", "Wheel Diameter" : "17 in.", "Color" : "Black", "Finish" : "Matte" } ', 4, 75.99, N'WHE-0001', N'Matte Finish Rim');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (15, 2, '2018-05-03 11:13:53.1591385', N' Clear bulb that with a universal fitting for all headlights/taillights.  Simple Installation, low wattage and a clear light for optimal visibility and efficiency.', 18, 0, 6.49, N'product_lighting_lightbulb.jpg', N'{ "Color" : "Clear", "Fit" : "Universal", "Wattage" : "30 Watts", "Includes Socket" : "Yes"}', 3, 6.49, N'LIG-0003', N'Turn Signal Light Bulb');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (16, 2, '2018-05-03 11:13:53.1591176', N'Our Bugeye Headlights use Halogen light bulbs are made to fit into a standard bugeye slot. Product requires some assembly and includes light bulbs.', 7, 0, 48.99, N'product_lighting_bugeye-headlight.jpg', N'{ "Light Source" : "Halogen", "Assembly Required": "Yes", "Color" : "Clear", "Interior" : "Chrome", "Beam": "low and high", "Wiring harness included" : "No", "Bulbs Included" : "Yes",  "Includes Parking Signal" : "Yes"}', 2, 48.99, N'LIG-0002', N'Bugeye Headlights (2 Pack)');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (17, 5, '2018-05-03 11:13:53.1591545', N'This Oil and Oil Filter combo is suitable for all types of passenger and light commercial vehicles. Providing affordable performance through excellent lubrication and breakdown resistance.', 5, 0, 34.49, N'product_oil_oil-filter-combo.jpg', N'{ "Filter Type" : "Canister", "Thread Size" : "0.75-16 in.", "Anti-Drainback Valve" : "Yes", "Size" : "1.1 gal.", "Synthetic" : "No" }', 17, 34.49, N'OIL-0002', N'Oil and Filter Combo');
        INSERT  INTO [dbo].[Products] ([ProductId], [CategoryId], [Created], [Description], [Inventory], [LeadTime], [Price], [ProductArtUrl], [ProductDetails], [RecommendationId], [SalePrice], [SkuNumber], [Title])
        VALUES                       (18, 5, '2018-05-03 11:13:53.1591549', N'This Oil is designed to reduce sludge deposits and metal friction throughout your cars engine. Provides performance no matter the condition or temperature.', 11, 0, 36.49, N'product_oil_premium-oil.jpg', N'{ "Size" :  "1.1 Gal." , "Synthetic " : "Yes"}', 18, 36.49, N'OIL-0003', N'Synthetic Engine Oil');
        SET IDENTITY_INSERT [dbo].[Products] OFF;
    END


GO