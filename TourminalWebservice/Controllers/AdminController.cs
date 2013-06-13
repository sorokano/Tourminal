using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BizUpgrade;

namespace TourminalWebservice.Controllers {
    public class AdminController : Controller {
        public ActionResult Index () {
            return View();
        }

        public ActionResult EditMainpage () {
            ViewData["VariableId"] = BizConstants.VariablesMainpageTextId;
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizVariables.GetVariableById(BizConstants.VariablesMainpageTextId));
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult EditMainpage (int id, string content) {
            BizVariables.UpdateRoute(id, content);
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizVariables.GetVariableById(BizConstants.VariablesMainpageTextId));
            return View();
        }
    }
}
