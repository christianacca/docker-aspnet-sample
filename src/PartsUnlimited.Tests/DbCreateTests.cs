using System.Data.Entity;
using NUnit.Framework;
using PartsUnlimited.Infrastructure;
using PartsUnlimited.Infrastructure.Migrations;

namespace PartsUnlimited.Tests
{
    [TestFixture]
    public class DbCreateTests
    {
        [SetUp]
        public void Setup()
        {
            // given
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<PartsUnlimitedContext, Configuration>());
            if (Database.Exists("PartsUnlimitedContext"))
            {
                Database.Delete("PartsUnlimitedContext");
            }
        }

        [Test]
        public void Can_create_db()
        {
            // when
            using (var db = new PartsUnlimitedContext())
            {
                db.Database.Initialize(true);
            }

            // then
            Assert.That(Database.Exists("PartsUnlimitedContext"), Is.True);
        }
    }
}