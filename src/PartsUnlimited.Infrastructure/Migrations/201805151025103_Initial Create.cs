namespace PartsUnlimited.Infrastructure.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.CartItems",
                c => new
                    {
                        CartItemId = c.Int(nullable: false, identity: true),
                        CartId = c.String(nullable: false),
                        Count = c.Int(nullable: false),
                        DateCreated = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        ProductId = c.Int(nullable: false),
                })
                .PrimaryKey(t => t.CartItemId, name: "PK_CartItems")
                .ForeignKey("dbo.Products", t => t.ProductId, cascadeDelete: true, name: "FK_CartItems_Products_ProductId")
                .Index(t => t.ProductId, name: "IX_CartItems_ProductId");
            
            CreateTable(
                "dbo.Products",
                c => new
                    {
                        ProductId = c.Int(nullable: false, identity: true),
                        CategoryId = c.Int(nullable: false),
                        Created = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        Description = c.String(nullable: false),
                        Inventory = c.Int(nullable: false),
                        LeadTime = c.Int(nullable: false),
                        Price = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProductArtUrl = c.String(nullable: false, maxLength: 1024),
                        ProductDetails = c.String(nullable: false),
                        RecommendationId = c.Int(nullable: false),
                        SalePrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SkuNumber = c.String(nullable: false),
                        Title = c.String(nullable: false, maxLength: 160),
                    })
                .PrimaryKey(t => t.ProductId, name: "PK_Products")
                .ForeignKey("dbo.Categories", t => t.CategoryId, cascadeDelete: true, name: "FK_Products_Categories_CategoryId")
                .Index(t => t.CategoryId, name: "IX_Products_CategoryId");
            
            CreateTable(
                "dbo.Categories",
                c => new
                    {
                        CategoryId = c.Int(nullable: false, identity: true),
                        Description = c.String(),
                        ImageUrl = c.String(),
                        Name = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.CategoryId, "PK_Categories");
            
            CreateTable(
                "dbo.OrderDetails",
                c => new
                    {
                        OrderDetailId = c.Int(nullable: false, identity: true),
                        OrderId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Int(nullable: false),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.OrderDetailId, name: "PK_OrderDetails")
                .ForeignKey("dbo.Orders", t => t.OrderId, cascadeDelete: true, name: "FK_OrderDetails_Orders_OrderId")
                .ForeignKey("dbo.Products", t => t.ProductId, cascadeDelete: true, name: "FK_OrderDetails_Products_ProductId")
                .Index(t => t.OrderId, name: "IX_OrderDetails_OrderId")
                .Index(t => t.ProductId, name: "IX_OrderDetails_ProductId");
            
            CreateTable(
                "dbo.Orders",
                c => new
                    {
                        OrderId = c.Int(nullable: false, identity: true),
                        Address = c.String(nullable: false, maxLength: 70),
                        City = c.String(nullable: false, maxLength: 40),
                        Country = c.String(nullable: false, maxLength: 40),
                        Email = c.String(nullable: false),
                        Name = c.String(nullable: false, maxLength: 160),
                        OrderDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        Phone = c.String(nullable: false, maxLength: 24),
                        PostalCode = c.String(nullable: false, maxLength: 10),
                        Processed = c.Boolean(nullable: false),
                        State = c.String(nullable: false, maxLength: 40),
                        Total = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Username = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.OrderId, name: "PK_Orders");
            
            CreateTable(
                "dbo.RainChecks",
                c => new
                    {
                        RaincheckId = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Int(nullable: false),
                        SalePrice = c.Double(nullable: false),
                        StoreId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.RaincheckId, name: "PK_RainChecks")
                .ForeignKey("dbo.Products", t => t.ProductId, cascadeDelete: true, name: "FK_RainChecks_Products_ProductId")
                .ForeignKey("dbo.Stores", t => t.StoreId, cascadeDelete: true, name: "FK_RainChecks_Stores_StoreId")
                .Index(t => t.ProductId, name: "IX_RainChecks_ProductId")
                .Index(t => t.StoreId, name: "IX_RainChecks_StoreId");
            
            CreateTable(
                "dbo.Stores",
                c => new
                    {
                        StoreId = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                    })
                .PrimaryKey(t => t.StoreId, name: "PK_Stores");

            SqlResource("PartsUnlimited.Infrastructure.Migrations.201805150816577_Initial creation_data_Up.sql");

        }
        
        public override void Down()
        {
            DropForeignKey("dbo.RainChecks", "ProductId", "dbo.Products");
            DropForeignKey("dbo.RainChecks", "StoreId", "dbo.Stores");
            DropForeignKey("dbo.CartItems", "ProductId", "dbo.Products");
            DropForeignKey("dbo.OrderDetails", "ProductId", "dbo.Products");
            DropForeignKey("dbo.OrderDetails", "OrderId", "dbo.Orders");
            DropForeignKey("dbo.Products", "CategoryId", "dbo.Categories");
            DropIndex("dbo.RainChecks", new[] { "StoreId" });
            DropIndex("dbo.RainChecks", new[] { "ProductId" });
            DropIndex("dbo.OrderDetails", new[] { "ProductId" });
            DropIndex("dbo.OrderDetails", new[] { "OrderId" });
            DropIndex("dbo.Products", new[] { "CategoryId" });
            DropIndex("dbo.CartItems", new[] { "ProductId" });
            DropTable("dbo.Stores");
            DropTable("dbo.RainChecks");
            DropTable("dbo.Orders");
            DropTable("dbo.OrderDetails");
            DropTable("dbo.Categories");
            DropTable("dbo.Products");
            DropTable("dbo.CartItems");
        }
    }
}
