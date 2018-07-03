using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using PartsUnlimited.Infrastructure;

namespace PartsUnlimited.Web
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            InitializeDb();
        }

        private void InitializeDb()
        {
            using (var db = new PartsUnlimitedContext())
            {
                db.Database.Initialize(false);
            }
        }
    }
}