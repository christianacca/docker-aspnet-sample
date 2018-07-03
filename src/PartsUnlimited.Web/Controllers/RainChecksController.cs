using System.Data.Entity;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using PartsUnlimited.Infrastructure;
using PartsUnlimited.Models;

namespace PartsUnlimited.Web.Controllers
{
    public class RainChecksController : Controller
    {
        private readonly PartsUnlimitedContext _db;

        public RainChecksController() : this(new PartsUnlimitedContext())
        {
        }

        public RainChecksController(PartsUnlimitedContext db)
        {
            _db = db;
        }

        // GET: RainChecks
        public async Task<ActionResult> Index()
        {
            var rainChecks = _db.RainChecks.Include(r => r.IssuerStore).Include(r => r.Product);
            return View(await rainChecks.ToListAsync());
        }

        // GET: RainChecks/Details/5
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            var rainCheck = await _db.RainChecks.FindAsync(id);
            if (rainCheck == null) return HttpNotFound();
            return View(rainCheck);
        }

        // GET: RainChecks/Create
        public ActionResult Create()
        {
            ViewBag.StoreId = new SelectList(_db.Stores, "StoreId", "Name");
            ViewBag.ProductId = new SelectList(_db.Products, "ProductId", "SkuNumber");
            return View();
        }

        // POST: RainChecks/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "RaincheckId,Name,ProductId,Quantity,SalePrice,StoreId")]
            RainCheck rainCheck)
        {
            if (ModelState.IsValid)
            {
                _db.RainChecks.Add(rainCheck);
                await _db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            ViewBag.StoreId = new SelectList(_db.Stores, "StoreId", "Name", rainCheck.StoreId);
            ViewBag.ProductId = new SelectList(_db.Products, "ProductId", "SkuNumber", rainCheck.ProductId);
            return View(rainCheck);
        }

        // GET: RainChecks/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            var rainCheck = await _db.RainChecks.FindAsync(id);
            if (rainCheck == null) return HttpNotFound();
            ViewBag.StoreId = new SelectList(_db.Stores, "StoreId", "Name", rainCheck.StoreId);
            ViewBag.ProductId = new SelectList(_db.Products, "ProductId", "SkuNumber", rainCheck.ProductId);
            return View(rainCheck);
        }

        // POST: RainChecks/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "RaincheckId,Name,ProductId,Quantity,SalePrice,StoreId")]
            RainCheck rainCheck)
        {
            if (ModelState.IsValid)
            {
                _db.Entry(rainCheck).State = EntityState.Modified;
                await _db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            ViewBag.StoreId = new SelectList(_db.Stores, "StoreId", "Name", rainCheck.StoreId);
            ViewBag.ProductId = new SelectList(_db.Products, "ProductId", "SkuNumber", rainCheck.ProductId);
            return View(rainCheck);
        }

        // GET: RainChecks/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            var rainCheck = await _db.RainChecks.FindAsync(id);
            if (rainCheck == null) return HttpNotFound();
            return View(rainCheck);
        }

        // POST: RainChecks/Delete/5
        [HttpPost]
        [ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            var rainCheck = await _db.RainChecks.FindAsync(id);
            _db.RainChecks.Remove(rainCheck);
            await _db.SaveChangesAsync();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) _db.Dispose();
            base.Dispose(disposing);
        }
    }
}