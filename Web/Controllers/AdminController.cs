using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using System.IO;
using System.Globalization;
using LinqToElcondor;
using ElcondorBiz;
using Elcondor.UI.Utilities;
using Elcondor.AdminHelpers;
using System.Xml;
using LinqToElcondor;
using Elcondor.Models;

namespace Elcondor.Controllers {
    public class AdminController : Controller {
        public ActionResult DictionaryList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            return View();
        }

        public ActionResult AddSpecialOffer () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            return View();
        }

        public ActionResult EditSpecialOffer () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindSpecialOffer(id);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult EditSpecialOffer (string txtId, string ddlCountry, string txtTitle, string txtShortDescription, string txtPrice, string txtLinkUrl, bool chkIsOnTop, string txtOrder, bool chkIsSpecOffer, bool chkIsReadyTour) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtId);
            int? order = null;
            try { order = int.Parse(txtOrder); } catch { order = null; }
            if (ValidateSpecialOffer(txtTitle, txtShortDescription, txtPrice, txtLinkUrl)) {
                BizAdminSpecialOffer.Update(id, txtTitle, txtShortDescription, string.Empty, float.Parse(txtPrice), txtLinkUrl, chkIsOnTop, chkIsReadyTour, int.Parse(ddlCountry), order, chkIsSpecOffer);
                Response.Redirect("/Admin/SpecialOffers");
            }
            BindSpecialOffer(id);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult AddSpecialOffer (string ddlCountry, string txtTitle, string txtShortDescription, string txtPrice, string txtLinkUrl, bool chkIsOnTop, bool chkIsReadyTour, bool chkIsSpecOffer) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            if (ValidateSpecialOffer(txtTitle, txtShortDescription, txtPrice, txtLinkUrl)) {
                BizAdminSpecialOffer.Add(int.Parse(ddlCountry), txtTitle, txtShortDescription, string.Empty, float.Parse(txtPrice), txtLinkUrl, chkIsOnTop, chkIsReadyTour, chkIsSpecOffer);
                Response.Redirect(string.Format("/Admin/SpecialOffers"));
            }
            return View();
        }

        public ActionResult Index () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            return View();
        }

        public ActionResult AddPage () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult AddPage (string content, string txtTitle) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BizPage.Add(txtTitle, content, true);
            Response.Redirect(string.Format("/Admin/FreePageList"));
            return View();
        }

        public ActionResult EditRecreationPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblRegionRecreation item = BizRegionRecreation.GetRegionRecreationById(id);
            ViewData["RecreationName"] = item.Name;
            ViewData["Id"] = item.Id;
            Session["RecreationId"] = id;
            return View();
        }

        public ActionResult SpecialOffers () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int filterCountryId = 0;
            try {
                filterCountryId = int.Parse(Request.QueryString["filterCountry"]);
            } catch {
                filterCountryId = 0;
            }
            try {
                int pageNumber = int.Parse(Request.QueryString["pageNumber"]);
                ViewData["pageNumber"] = pageNumber;
            } catch {
                ViewData["pageNumber"] = 1;
            }
            int sortByField = Constants.ColTourListId;
            bool isDesc = false;
            if (Session["IsDesc"] != null) {
                isDesc = !bool.Parse(Session["IsDesc"].ToString());
                Session["IsDesc"] = isDesc;
            } else {
                Session["IsDesc"] = true;
            }
            if (Request.QueryString["SortBy"] == null) {
                isDesc = true;
            } else {
                sortByField = int.Parse(Request.QueryString["SortBy"].ToString());
            }
            ViewData["GridTourList"] = AdminHelpers.GridTourListHelper.GetGridHTML(filterCountryId, sortByField, isDesc, true);
            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", Constants.NoValueSelected);
            return View();
        }

        public ActionResult AddNews () {
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddNews (string txtTitle, string txtDescr) {
            if (!ValidateAddNews(txtTitle, txtDescr)) {

                return View();
            }
            bool result = BizAdminNews.Add(txtDescr, txtTitle);
            Response.Redirect("/Admin/NewsList");
            return View();
        }

        public ActionResult EditNews () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindNewsData(id);
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditNews (string txtId, string txtTitle, string txtDescr) {
            if (!ValidateAddNews(txtTitle, txtDescr)) {
                BindNewsData(int.Parse(txtId));
                return View();
            }
            BizAdminNews.Update(int.Parse(txtId), txtDescr, txtTitle);
            Response.Redirect("/Admin/NewsList");
            return View();
        }

        public ActionResult EditNewsPhoto () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindNewsData(id);
            return View();
        }

        public JsonResult DeleteNewsThumbImage (int NewsId) {
            BizAdminNews.DeleteThumbImage(NewsId);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteNewsLargeImage (int NewsId) {
            BizAdminNews.DeleteLargeImage(NewsId);
            return Json(Constants.JSONPositiveResult);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadNewsThumbImg (HttpPostedFileBase fileUpload, string txtNewsId) {

            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("news_th_{0}.jpg", txtNewsId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, 270);
                    BizAdminNews.UploadThumbImg(int.Parse(txtNewsId), pic);
                    Session["ImageUploaded"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            Response.Redirect(string.Format("/Admin/EditNewsPhoto?id={0}", txtNewsId));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadNewsLargeImg (HttpPostedFileBase fileUpload1, string txtNewsId) {

            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("news_{0}.jpg", txtNewsId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, 340);
                    BizAdminNews.UploadLargeImg(int.Parse(txtNewsId), pic);
                    Session["ImageUploaded2"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            Response.Redirect(string.Format("/Admin/EditNewsPhoto?id={0}", txtNewsId));
        }

        public ActionResult NewsList () {
            //if (!CheckIsLogon(this.Session))
            //    Response.Redirect("/Admin/Login");
            StringBuilder sb = new System.Text.StringBuilder();
            //sb.Append(string.Format("<li><a href=\"../../Admin/EditModulePage?id={0}\">Основная страница</a></li>", parentPage.Id));
            //foreach (TblPage itm in BizPage.GetChildPageList(parentPage.Id, true)) {
            //    sb.Append(string.Format("<li><a href=\"../../Admin/EditModulePage?id={0}\">{1}</a></li>", itm.Id, itm.Title));
            //}
            //sb.Append("Тут будет список новостей.");
            //ViewData["GridChildPageList"] = sb.ToString();
            ViewData["PageId"] = Constants.PageIndexId.ToString();
            ViewData["GridPageList"] = AdminHelpers.GridNewsListHelper.GetGridHTML(BizNews.GetNewsList());//PageListHelper.GetPageListGridHTML(Constants.PageIndexId);
            return View();
        }

        public JsonResult DeleteNews (int imageId) {
            BizAdminNews.Delete(imageId);
            return Json(Constants.JSONPositiveResult);
        }

        private void BindNewsData (int id) {
            TblNews itm = BizNews.GetNewsById(id);
            ViewData["NewsId"] = itm.Id;
            ViewData["NewsDate"] = itm.DateCreated.ToString("dd.MM.yyyy");
            ViewData["NewsTitle"] = itm.Title;
            ViewData["NewsDesc"] = itm.Description;
            bool hasThumbImage = false;
            try {
                hasThumbImage = itm.ThumbImage.Length > 0;
            } catch { hasThumbImage = false; }
            ViewData["NewsHasThumbImage"] = hasThumbImage;
            bool hasLargeImage = false;
            try {
                hasLargeImage = itm.LargeImage.Length > 0;
            } catch { hasLargeImage = false; }
            ViewData["NewsHasLargeImage"] = hasLargeImage;
            if (hasLargeImage) {
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                , string.Format("news_{0}.jpg", itm.Id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(itm.LargeImage.ToArray());
                img.Save(filePath);
            }
            if (hasThumbImage) {
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("news_th_{0}.jpg", itm.Id));
                byte[] pic;
                System.Drawing.Image img = UIHelper.ByteArrayToImage(itm.ThumbImage.ToArray());
                img.Save(filePath);
            }
        }

        public bool ValidateAddNews (string txtTitle, string txtDescr) {
            if (String.IsNullOrEmpty(txtTitle)) {
                ModelState.AddModelError("txtTitle", "Укажите заголовок новости.");
            }
            if (String.IsNullOrEmpty(txtDescr)) {
                ModelState.AddModelError("txtDescr", "Укажите описание.");
            }
            return ModelState.IsValid;
        }

        public ActionResult SightseeingList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            this.ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true), "Id", "Name", string.Empty);
            int filterCountryId = 0;
            try {
                filterCountryId = int.Parse(Request.QueryString["filterCountry"]);
            } catch {
                filterCountryId = 0;
            }
            try {
                int pageNumber = int.Parse(Request.QueryString["pageNumber"]);
                ViewData["pageNumber"] = pageNumber;
            } catch {
                ViewData["pageNumber"] = 1;
            }
            int sortByField = Constants.ColSightseeingListId;
            bool isDesc = false;
            if (Session["IsDesc"] != null) {
                isDesc = !bool.Parse(Session["IsDesc"].ToString());
                Session["IsDesc"] = isDesc;
            } else {
                Session["IsDesc"] = true;
            }
            if (Request.QueryString["SortBy"] == null) {
                isDesc = true;
            } else {
                sortByField = int.Parse(Request.QueryString["SortBy"].ToString());
            }
            this.ViewData["ddlDlgDistrict"] = new SelectList(new List<SelectListItem>());
            ViewData["GridSightseeingList"] = GridSightseeingListHelper.GetGridSightseeingListHTML(filterCountryId, sortByField, isDesc);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void SortSightseeingGrid (string sortBy) {
            if (Session["SortBy"] == null) {
                Session["SortBy"] = sortBy;
                Session["IsDesc"] = Boolean.FalseString;
            } else if (sortBy == Session["SortBy"].ToString()) {
                Session["IsDesc"] = !(bool.Parse(Session["IsDesc"].ToString()));
            } else if (sortBy != Session["SortBy"].ToString())
                Session["SortBy"] = sortBy;
        }

        public JsonResult RemoveSightseeing (int SightseeingId) {
            BizAdminSightseeing.Delete(SightseeingId);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult RemoveTour (int id) {
            BizAdminTour.Delete(id);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult RemoveSpecialOffer (int id) {
            BizAdminSpecialOffer.Delete(id);
            return Json(Constants.JSONPositiveResult);
        }

        public ActionResult FreePageList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            if (Request.QueryString["id"] != null) {
                int id = int.Parse(Request.QueryString["id"].ToString());
                ViewData["PageId"] = id;
                ViewData["PageUrl"] = string.Format("http://www.tourminal.ru/Home/Page?id={0}", id);
                ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(id).Text);
            }
            ViewData["PageList"] = PageListHelper.GetListHTML(true);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult FreePageList (string content, int pageId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BizPage.Update(pageId, content);
            ViewData["PageId"] = pageId;
            ViewData["PageUrl"] = string.Format("http://www.tourminal.ru/Home/Page?id={0}", pageId);
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(pageId).Text);
            Response.Redirect(string.Format("/Admin/PageList?id={0}", pageId));
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(pageId).Text);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult PageList (string content, int pageId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BizPage.Update(pageId, content);
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(pageId).Text);
            Response.Redirect(string.Format("/Admin/PageList?id={0}", pageId));
            ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(pageId).Text);
            return View();
        }

        public ActionResult PageList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            ViewData["PageList"] = PageListHelper.GetListHTML(false);
            if (Request.QueryString["id"] != null) {
                int id = int.Parse(Request.QueryString["id"].ToString());
                ViewData["PageId"] = id;
                ViewData["EditField"] = string.Format("<textarea name=\"content\">{0}</textarea>", BizDictionary.GetPageById(id).Text);
            }
            return View();
        }

        public ActionResult SightseeingTypeList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            ViewData["DictionaryItemType"] = Constants.DictionaryItemSightseeing;
            ViewData["GridDictionary"] = GridSightseeingTypeList.GetGridHTML(DictionaryHelper.GetSightseeingTypeListData());
            return View();
        }

        public ActionResult CountryList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            return View();
        }

        public ActionResult CountryEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int countryId = int.Parse(Request.QueryString["id"].ToString());
            BindCountryData(countryId);
            BindCountryInfoList(countryId);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult CountryEdit (string contentVisa, string txtCountryId, string contentAdditional) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtCountryId);
            BizAdminCountry.UpdateCountryDetails(id, contentVisa, contentAdditional);
            BindCountryData(id);
            BindCountryInfoList(id);
            Response.Redirect(string.Format("/Admin/CountryEdit?id={0}", id));
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CityAssignCapital (string ddlCity) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int cityId = int.Parse(ddlCity);
            BizAdminCity.UpdateCityCapital(cityId, true);
            Response.Redirect(string.Format("/Admin/CountryEdit?id={0}", BizCity.GetCityById(cityId).CountryId));
            return View("CountryEdit");
        }

        public ActionResult CityEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindCityData(id);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult CityEdit (string contentDescr, string txtLatitude, string txtLongitude, string txtCityId, bool isBeach) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtCityId);
            BizAdminCity.Update(id, contentDescr, txtLatitude, txtLongitude, isBeach);
            BindCityData(id);
            Response.Redirect(string.Format("/Admin/CityEdit?id={0}", id));
            return View();
        }

        public ActionResult RegionEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindRegionData(id);
            ViewData["DictionaryItemType"] = Constants.DictionaryItemRegionRecreation;
            ViewData["GridRegionRecreation"] = GridRegionRecreationListHelper.GetGridHTML(BizRegionRecreation.GetListByRegionId(id));
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        public ActionResult RegionEdit (string txtRegionId, string contentDescr, string txtLatitude, string txtLongitude) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtRegionId);
            BizAdminRegion.Update(id, contentDescr, BizRegion.GetRegionById(id).Name, txtLatitude, txtLongitude);
            BindRegionData(id);
            ViewData["DictionaryItemType"] = Constants.DictionaryItemRegionRecreation;
            ViewData["GridRegionRecreation"] = GridRegionRecreationListHelper.GetGridHTML(BizRegionRecreation.GetListByRegionId(id));
            Response.Redirect(string.Format("RegionEdit?id={0}", id));
            return View();
        }

        public ActionResult AddSightseeing () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            try {
                int id = int.Parse(Request.QueryString["id"].ToString());
                Session["SightseeingId"] = id;
                ViewData["Id"] = id;
                ViewData["SightseeingImgUploadCount"] = BizSightseeing.GetSightseeingPhotoCount(id);
                BindSightseeingData(id);
            } catch {
                BindSightseeingData(null);
            }
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddSightseeing (string txtId, string ddlSightseeingType, string ddlCountry, string ddlDistrict, string txtSightseeingName, string txtSightseeingShortDesc, string content, string[] ddlDistrict2) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int? id = null;
            if (!string.IsNullOrEmpty(txtId))
                id = int.Parse(txtId);
            if (string.IsNullOrEmpty(txtSightseeingName)) {
                AddValidationMessage("Введите название статьи.", txtSightseeingName);
            } else if (ddlDistrict2 == null && !id.HasValue) {
                AddValidationMessage("Добавьте регион.", txtSightseeingName);
            } else {
                if (id == 0) {
                    List<int> regs = new List<int>();
                    if (ddlDistrict2 != null)
                        foreach (string reg in ddlDistrict2) {
                            regs.Add(int.Parse(reg));
                            if (int.Parse(reg) == -1) {
                                regs = new List<int>();
                                break;
                            }
                        }
                    id = BizAdminSightseeing.Add(txtSightseeingName, content, txtSightseeingShortDesc, regs, int.Parse(ddlCountry), int.Parse(ddlSightseeingType));
                } else {
                    BizAdminSightseeing.Update(id.Value, txtSightseeingName, content, txtSightseeingShortDesc, int.Parse(ddlSightseeingType));
                }
                Response.Redirect(string.Format("AddSightseeing?typeid={0}&regionid={1}&id={2}", ddlSightseeingType, 0, id.Value));
            }
            BindSightseeingData(id == 0 ? null : id);
            return View();
        }

        public ActionResult EditSightseeingPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblSightseeing item = BizSightseeing.GetSightseeingById(id);
            ViewData["SightseeingName"] = item.Name;
            ViewData["Id"] = item.Id;
            byte[] image = BizSightseeing.GetImage(id);
            if (image != null) {
                Session["ImageUploaded"] = Constants.JSONPositiveResult;
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("sightseeing_th_{0}.jpg", id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(image);
                img.Save(filePath);
            }
            Session["SightseeingId"] = id;
            return View();
        }

        public ActionResult EditSpecialOfferPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblSpecialOffer item = BizSpecialOffer.GetSpecialOfferById(id);
            BindSpecialOffer(id);
            byte[] image = BizSpecialOffer.GetImage(id);
            if (image != null) {
                Session["ImageUploaded"] = Constants.JSONPositiveResult;
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("specialoffer_th_{0}.jpg", id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(image);
                img.Save(filePath);
            }
            Session["SpecialOfferId"] = id;
            return View();
        }

        public ActionResult EditCityPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindCityData(id);
            Session["CityId"] = id;
            return View();
        }

        public JsonResult DeleteSpecialOfferThumbImage (int specialOfferId) {
            BizAdminSpecialOffer.DeleteThumbImage(specialOfferId);
            Session["ImageUploaded"] = null;
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteSightseeingThumbImage (int sightseeingImageId) {
            BizAdminSightseeing.DeleteSightseeingThumbImage(sightseeingImageId);
            Session["ImageUploaded"] = null;
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteTourThumbImage (int tourId) {
            BizAdminTour.DeleteThumbImage(tourId);
            Session["ImageUploaded"] = null;
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteSightseeingImage (int sightseeingImageId) {
            BizAdminSightseeing.DeleteSightseeingImage(sightseeingImageId);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteRecreationImage (int recreationImageId) {
            BizAdminRegionRecreation.DeleteRecreationImage(recreationImageId);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteCityImage (int cityImageId) {
            BizAdminCity.DeleteCityImage(cityImageId);
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteTagItem (string id) {
            BizAdminTag.Delete(int.Parse(id));
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult DeleteDictionaryItem (string parameters) {
            List<string> items = parameters.Split('|').ToList();
            int itemId = int.Parse(items[0]);
            switch (items[1]) {
                case Constants.DictionaryItemSightseeing:
                    BizAdminSightseeingType.Delete(itemId);
                    break;
                case Constants.DictionaryItemRegionRecreation:
                    BizAdminRegionRecreation.Delete(int.Parse(items[0]));
                    break;
                case Constants.DictionaryItemCountry:
                    BizAdminCountry.DeleteCountry(int.Parse(items[0]));
                    break;
                case Constants.DictionaryItemDistrict:
                    BizAdminRegion.Delete(int.Parse(items[0]));
                    break;
                case Constants.DictionaryItemCity:
                    BizAdminCity.Delete(int.Parse(items[0]));
                    break;
                case Constants.DictionaryItemCountryInfo:
                    BizAdminCountry.DeleteCountryInfo(int.Parse(items[0]));
                    break;
            }
            return Json(Constants.JSONPositiveResult);
        }

        public JsonResult UpdateCityImageDescription (int cityImageId, string description) {
            BizImage.Update(cityImageId, description);
            return Json(Constants.JSONPositiveResult);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadImg (HttpPostedFileBase fileUpload, string txtSightseeingId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("sightseeing_th_{0}.jpg", txtSightseeingId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, 122);
                    BizSightseeing.UploadImg(int.Parse(txtSightseeingId), pic);
                    Session["ImageUploaded"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            Response.Redirect(string.Format("/Admin/EditSightseeingPhoto?id={0}", txtSightseeingId));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadSpecialOfferImg (HttpPostedFileBase fileUpload, string txtSpecialOfferId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("specialoffer_th_{0}.jpg", txtSpecialOfferId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, 180);
                    BizAdminSpecialOffer.UploadImg(int.Parse(txtSpecialOfferId), pic);
                    Session["ImageUploaded"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            Response.Redirect(string.Format("/Admin/EditSpecialOfferPhoto?id={0}", txtSpecialOfferId));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadTourImg (HttpPostedFileBase fileUpload, string txtId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("tour_th_{0}.jpg", txtId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, 180);
                    BizTour.UploadImg(int.Parse(txtId), pic);
                    Session["ImageUploaded"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            TblTour tour = BizTour.GetTourById(int.Parse(txtId));
            if (tour.IsCruise.Value)
                Response.Redirect(string.Format("/Admin/EditCruisePhoto?id={0}", txtId));
            if (tour.IsExcursion.Value)
                Response.Redirect(string.Format("/Admin/EditExcursPhoto?id={0}", txtId));
            Response.Redirect(string.Format("/Admin/EditTourPhoto?id={0}", txtId));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public void UploadCountryFlagImg (HttpPostedFileBase fileUpload, string txtCountryId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            foreach (string inputTagName in Request.Files) {
                HttpPostedFileBase file = Request.Files[inputTagName];
                if (file.ContentLength > 0) {
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("flag_{0}.jpg", txtCountryId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, Constants.ImgMaxFlagHeight);
                    BizCountry.UploadImg(int.Parse(txtCountryId), pic);
                    Session["ImageUploaded"] = Constants.JSONPositiveResult;
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            Response.Redirect(string.Format("/Admin/CountryEdit?id={0}", txtCountryId));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UploadSightseeingImages (IEnumerable<HttpPostedFileBase> fileData) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int sightseeingId = int.Parse(Session["SightseeingId"].ToString());
            foreach (HttpPostedFileBase file in fileData) {
                if (file.ContentLength > 0) {
                    int newImageId = BizAdminSightseeing.AddImage(sightseeingId, string.Empty);
                    int photoalbumId = BizPhotoImage.GetImageById(newImageId).PhotoalbumId;
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("album_{0}_image_{1}.jpg", photoalbumId, newImageId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, Constants.ImgMaxAlbumImageHeight);
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            return Json(new { Status = "OK" });
        }


        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UploadRecreationImages (IEnumerable<HttpPostedFileBase> fileData) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int recreationId = int.Parse(Session["RecreationId"].ToString());
            foreach (HttpPostedFileBase file in fileData) {
                if (file.ContentLength > 0) {
                    int newImageId = BizAdminRegionRecreation.AddImage(recreationId, string.Empty);
                    int photoalbumId = BizPhotoImage.GetImageById(newImageId).PhotoalbumId;
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("recreation_{0}_image_{1}.jpg", photoalbumId, newImageId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, Constants.ImgMaxAlbumImageHeight);
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            return Json(new { Status = "OK" });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UploadCityImages (IEnumerable<HttpPostedFileBase> fileData) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int cityId = int.Parse(Session["CityId"].ToString());
            foreach (HttpPostedFileBase file in fileData) {
                if (file.ContentLength > 0) {
                    int newImageId = BizAdminCity.AddImage(cityId, string.Empty);
                    int photoalbumId = BizPhotoImage.GetImageById(newImageId).PhotoalbumId;
                    string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("album_{0}_image_{1}.jpg", photoalbumId, newImageId));
                    byte[] pic;
                    UIHelper.GetImageBytesWithExtension(file, out pic, Constants.ImgMaxAlbumImageHeight);
                    System.Drawing.Image img = UIHelper.ByteArrayToImage(pic);
                    img.Save(filePath);
                }
            }
            return Json(new { Status = "OK" });
        }

        public ActionResult AddCruise () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            return View();
        }

        public ActionResult AddExcurs () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            return View();
        }

        public ActionResult AddTour () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddExcurs (string content, string txtExcursName, string ddlCountry, string[] ddlDistrict2) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            if (!ValidateTour(txtExcursName, ddlCountry, ddlDistrict2)) {
                return View();
            }
            List<int> regs = new List<int>();
            foreach (string reg in ddlDistrict2)
                regs.Add(int.Parse(reg));
            BizAdminTour.Add(content, txtExcursName, regs, true, false, int.Parse(ddlCountry));
            Response.Redirect("/Admin/ExcursList");
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddCruise (string content, string txtCruiseName, string ddlCountry, string[] ddlDistrict2) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            if (!ValidateTour(txtCruiseName, ddlCountry, ddlDistrict2)) {
                return View();
            }
            List<int> regs = new List<int>();
            foreach (string reg in ddlDistrict2)
                regs.Add(int.Parse(reg));
            BizAdminTour.Add(content, txtCruiseName, regs, false, true, int.Parse(ddlCountry));
            Response.Redirect("/Admin/CruiseList");
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddTour (string content, string txtTourName, string ddlCountry, string[] ddlDistrict2) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            BindCountryDdl();
            if (!ValidateTour(txtTourName, ddlCountry, ddlDistrict2)) {
                return View();
            }
            List<int> regs = new List<int>();
            foreach (string reg in ddlDistrict2)
                regs.Add(int.Parse(reg));
            BizAdminTour.Add(content, txtTourName, regs, false, false, int.Parse(ddlCountry));
            Response.Redirect("/Admin/TourList");
            return View();
        }

        public ActionResult CountryListEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            ViewData["DictionaryItemType"] = Constants.DictionaryItemCountry;
            ViewData["GridCountryList"] = GridCountryListHelper.GetGridHTML(DictionaryHelper.GetCountryListData());
            return View();
        }

        public ActionResult RegionListEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int countryId = int.Parse(Request.QueryString["countryId"].ToString());
            ViewData["CountryName"] = BizCountry.GetCountryById(countryId).Name;
            ViewData["CountryId"] = countryId;
            ViewData["DictionaryItemType"] = Constants.DictionaryItemDistrict;
            ViewData["GridList"] = GridRegionListHelper.GetGridHTML(DictionaryHelper.GetDistrictListData(countryId), countryId);
            return View();
        }

        public ActionResult CityListEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            ViewData["DictionaryItemType"] = Constants.DictionaryItemCity;
            int regionId = int.Parse(Request.QueryString["regionId"].ToString());
            TblRegion region = BizRegion.GetRegionById(regionId);
            TblCountry country = BizCountry.GetCountryById(region.CountryId);
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            ViewData["RegionName"] = region.Name;
            ViewData["RegionId"] = regionId;
            ViewData["GridList"] = GridCityListHelper.GetGridHTML(DictionaryHelper.GetAllCityListData(regionId));
            return View();
        }

        public ActionResult TourList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int filterCountryId = 0;
            try {
                filterCountryId = int.Parse(Request.QueryString["filterCountry"]);
            } catch {
                filterCountryId = 0;
            }
            try {
                int pageNumber = int.Parse(Request.QueryString["pageNumber"]);
                ViewData["pageNumber"] = pageNumber;
            } catch {
                ViewData["pageNumber"] = 1;
            }
            int sortByField = Constants.ColTourListId;
            bool isDesc = false;
            if (Session["IsDesc"] != null) {
                isDesc = !bool.Parse(Session["IsDesc"].ToString());
                Session["IsDesc"] = isDesc;
            } else {
                Session["IsDesc"] = true;
            }
            if (Request.QueryString["SortBy"] == null) {
                isDesc = true;
            } else {
                sortByField = int.Parse(Request.QueryString["SortBy"].ToString());
            }
            ViewData["GridTourList"] = AdminHelpers.GridTourListHelper.GetGridHTML(filterCountryId, sortByField, isDesc);
            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", Constants.NoValueSelected);
            return View();
        }

        public ActionResult TourEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            //BindRegionData(tour.RegionId);
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TourEdit (string txtId, string txtName, string txtDescription, string txtPrice, string txtProgram, string txtTourDays, string txtTourPopularity, bool chkIsSpecialOffer, bool chkIsReadyTour) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtId);
            if (string.IsNullOrEmpty(txtName)) {
                AddValidationMessage("Введите название маршрута.", txtName);
            } else {
                double? price = null;
                int? days = null;
                int? popularity = null;
                if (!string.IsNullOrEmpty(txtPrice))
                    price = Convert.ToDouble(txtPrice);
                if (!string.IsNullOrEmpty(txtTourDays))
                    days = Convert.ToInt32(txtTourDays);
                if (!string.IsNullOrEmpty(txtTourPopularity))
                    popularity = Convert.ToInt32(txtTourPopularity);
                BizAdminTour.Update(id, txtDescription, txtName, false, false, price, txtProgram, days, null, popularity, chkIsSpecialOffer, chkIsReadyTour);
                Response.Redirect(string.Format("TourEdit?id={0}", id));
            }
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            return View();
        }

        public ActionResult ExcursEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ExcursEdit (string txtId, string txtName, string txtDescription, string txtPrice, string txtProgram, string txtTourDays, string txtTourHours, string txtTourPopularity, bool chkIsSpecialOffer, bool chkIsReadyTour) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtId);
            if (string.IsNullOrEmpty(txtName)) {
                AddValidationMessage("Введите название маршрута.", txtName);
            } else {
                double? price = null;
                int? days = null;
                int? popularity = null;
                int? hours = null;
                if (!string.IsNullOrEmpty(txtPrice))
                    price = Convert.ToDouble(txtPrice);
                if (!string.IsNullOrEmpty(txtTourDays))
                    days = Convert.ToInt32(txtTourDays);
                if (!string.IsNullOrEmpty(txtTourPopularity))
                    days = Convert.ToInt32(txtTourPopularity);
                if (!string.IsNullOrEmpty(txtTourHours))
                    popularity = Convert.ToInt32(txtTourHours);
                BizAdminTour.Update(id, txtDescription, txtName, true, false, price, txtProgram, days, hours, popularity, chkIsSpecialOffer, chkIsReadyTour);
                Response.Redirect(string.Format("ExcursEdit?id={0}", id));
            }
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            return View();
        }

        public ActionResult CruiseEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CruiseEdit (string txtId, string txtName, string txtDescription, string txtPrice, string txtProgram, string txtTourDays, string txtTourPopularity, bool chkIsSpecialOffer, bool chkIsReadyTour) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtId);
            if (string.IsNullOrEmpty(txtName)) {
                AddValidationMessage("Введите название маршрута.", txtName);
            } else {
                double? price = null;
                int? days = null;
                int? popularity = null;
                if (!string.IsNullOrEmpty(txtPrice))
                    price = Convert.ToDouble(txtPrice);
                if (!string.IsNullOrEmpty(txtTourDays))
                    days = Convert.ToInt32(txtTourDays);
                if (!string.IsNullOrEmpty(txtTourPopularity))
                    popularity = Convert.ToInt32(txtTourPopularity);
                BizAdminTour.Update(id, txtDescription, txtName, false, true, price, txtProgram, days, null, popularity, chkIsSpecialOffer, chkIsReadyTour);
                Response.Redirect(string.Format("CruiseEdit?id={0}", id));
            }
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            return View();
        }

        public ActionResult EditTourPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            byte[] image = BizTour.GetImage(id);
            if (image != null) {
                Session["ImageUploaded"] = Constants.JSONPositiveResult;
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("tour_th_{0}.jpg", id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(image);
                img.Save(filePath);
            }
            Session["TourId"] = id;
            return View();
        }

        public ActionResult EditExcursPhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            byte[] image = BizTour.GetImage(id);
            if (image != null) {
                Session["ImageUploaded"] = Constants.JSONPositiveResult;
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("tour_th_{0}.jpg", id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(image);
                img.Save(filePath);
            }
            Session["TourId"] = id;
            return View();
        }

        public ActionResult CountryInfoEdit () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblCountryInfo info = BizCountry.GetCountryInfoById(id);
            BindCountryInfoData(info);
            BindCountryData(info.CountryId);
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountryInfoEdit (string txtId, string txtTitle, string content, string txtPageOrder) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(txtId);
            TblCountryInfo info = BizCountry.GetCountryInfoById(id);
            if (ValidateCountryInfo(txtTitle, content, txtPageOrder)) {
                BizAdminCountry.UpdateCountryInfo(id, content, txtTitle, int.Parse(txtPageOrder));
                Response.Redirect(string.Format("/Admin/CountryEdit?id={0}", info.CountryId));
            }
            BindCountryInfoData(info);
            BindCountryData(info.CountryId);
            return View();
        }

        private void BindCountryInfoData (TblCountryInfo info) {
            ViewData["CountryInfoId"] = info.Id;
            ViewData["PageOrder"] = info.PageOrder;
            ViewData["Title"] = info.Title;
            ViewData["ContentInfoDescription"] = info.Description;
        }

        public ActionResult EditCruisePhoto () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblTour tour = BindTourData(id);
            BindTourRegionData(BizTour.GetTourRegionList(id));
            byte[] image = BizTour.GetImage(id);
            if (image != null) {
                Session["ImageUploaded"] = Constants.JSONPositiveResult;
                string filePath = Path.Combine(HttpContext.Server.MapPath("../Content/UserImages")
                    , string.Format("tour_th_{0}.jpg", id));
                System.Drawing.Image img = UIHelper.ByteArrayToImage(image);
                img.Save(filePath);
            }
            Session["TourId"] = id;
            return View();
        }

        public ActionResult ExcursList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int filterCountryId = 0;
            try {
                filterCountryId = int.Parse(Request.QueryString["filterCountry"]);
            } catch {
                filterCountryId = 0;
            }
            try {
                int pageNumber = int.Parse(Request.QueryString["pageNumber"]);
                ViewData["pageNumber"] = pageNumber;
            } catch {
                ViewData["pageNumber"] = 1;
            }
            int sortByField = Constants.ColTourListId;
            bool isDesc = false;
            if (Session["IsDesc"] != null) {
                isDesc = !bool.Parse(Session["IsDesc"].ToString());
                Session["IsDesc"] = isDesc;
            } else {
                Session["IsDesc"] = true;
            }
            if (Request.QueryString["SortBy"] == null) {
                isDesc = true;
            } else {
                sortByField = int.Parse(Request.QueryString["SortBy"].ToString());
            }
            ViewData["GridExcursList"] = AdminHelpers.GridExcursListHelper.GetGridHTML(filterCountryId, sortByField, isDesc);
            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", Constants.NoValueSelected);
            return View();
        }

        public ActionResult CruiseList () {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            int filterCountryId = 0;
            try {
                filterCountryId = int.Parse(Request.QueryString["filterCountry"]);
            } catch {
                filterCountryId = 0;
            }
            try {
                int pageNumber = int.Parse(Request.QueryString["pageNumber"]);
                ViewData["pageNumber"] = pageNumber;
            } catch {
                ViewData["pageNumber"] = 1;
            }
            int sortByField = Constants.ColTourListId;
            bool isDesc = false;
            if (Session["IsDesc"] != null) {
                isDesc = !bool.Parse(Session["IsDesc"].ToString());
                Session["IsDesc"] = isDesc;
            } else {
                Session["IsDesc"] = true;
            }
            if (Request.QueryString["SortBy"] == null) {
                isDesc = true;
            } else {
                sortByField = int.Parse(Request.QueryString["SortBy"].ToString());
            }
            ViewData["GridCruiseList"] = AdminHelpers.GridCruiseListHelper.GetGridHTML(filterCountryId, sortByField, isDesc);
            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", Constants.NoValueSelected);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditCountryListItem (string txtItemValue, string txtItemId, string txtItemType) {
            switch (txtItemType) {
                case Constants.DictionaryItemCountry:
                    BizAdminCountry.UpdateCountry(int.Parse(txtItemId), txtItemValue);
                    break;
                case Constants.DictionaryItemDistrict:
                    BizAdminRegion.Update(int.Parse(txtItemId), txtItemValue);
                    break;
                case Constants.DictionaryItemCity:
                    BizAdminCountry.UpdateCity(int.Parse(txtItemId), txtItemValue);
                    break;
                case Constants.DictionaryItemSightseeing:
                    BizAdminSightseeingType.Update(int.Parse(txtItemId), txtItemValue);
                    break;
            }
            BindCountryDdl();
            return View("CountryList");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditDictionaryItem (string txtItemValue, string txtItemId, string txtItemType, string txtParentItemId) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            string redirectUrl = GetDictionaryItemPage(txtItemType);
            if (string.IsNullOrEmpty(txtItemValue))
                Response.Redirect(redirectUrl);
            switch (txtItemType) {
                case Constants.DictionaryItemSightseeing:
                    if (txtItemId != Constants.JSONNullElementValue)
                        BizAdminSightseeingType.Update(int.Parse(txtItemId), txtItemValue);
                    else
                        BizAdminSightseeingType.Add(txtItemValue);
                    ViewData["GridDictionary"] = GridSightseeingTypeList.GetGridHTML(DictionaryHelper.GetSightseeingTypeListData());
                    break;
                case Constants.DictionaryItemCountry:
                    if (txtItemId != Constants.JSONNullElementValue)
                        BizAdminCountry.UpdateCountry(int.Parse(txtItemId), txtItemValue);
                    else
                        BizAdminCountry.AddCountry(txtItemValue);
                    ViewData["GridDictionary"] = GridCountryListHelper.GetGridHTML(DictionaryHelper.GetCountryListData());
                    break;
                case Constants.DictionaryItemDistrict:
                    if (txtItemId != Constants.JSONNullElementValue)
                        BizAdminRegion.Update(int.Parse(txtItemId), txtItemValue);
                    else
                        BizAdminRegion.Add(int.Parse(txtParentItemId), txtItemValue);
                    ViewData["GridList"] = GridRegionListHelper.GetGridHTML(DictionaryHelper.GetDistrictListData(int.Parse(txtParentItemId)), int.Parse(txtParentItemId));
                    redirectUrl = redirectUrl + "?countryId=" + txtParentItemId;
                    break;
                case Constants.DictionaryItemCity:
                    if (txtItemId != Constants.JSONNullElementValue)
                        BizAdminCity.Update(int.Parse(txtItemId), txtItemValue);
                    else
                        BizAdminCity.Add(int.Parse(txtParentItemId), txtItemValue);
                    ViewData["GridList"] = GridCityListHelper.GetGridHTML(DictionaryHelper.GetCityListData(int.Parse(txtParentItemId)));
                    redirectUrl = redirectUrl + "?regionId=" + txtParentItemId;
                    break;
                case Constants.DictionaryItemCountryInfo:
                    BizAdminCountry.AddCountryInfo(int.Parse(txtParentItemId), string.Empty, txtItemValue, -1);
                    redirectUrl = redirectUrl + "?id=" + txtParentItemId;
                    break;
            }
            Response.Redirect(redirectUrl);
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditRecreationItem (string txtDlgItemDescription, string txtDlgItemId, string txtDlgRegionId, string txtDlgItemName, string txtDlgItemOrder) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            string redirectUrl = "/Admin/RegionEdit?id={0}";
            int itemOrder = 0;
            try { itemOrder = int.Parse(txtDlgItemOrder); } catch { }
            if (txtDlgItemId != Constants.JSONNullElementValue)
                BizAdminRegionRecreation.Update(int.Parse(txtDlgItemId), txtDlgItemDescription, txtDlgItemName, itemOrder);
            else
                BizAdminRegionRecreation.Add(int.Parse(txtDlgRegionId), txtDlgItemDescription, txtDlgItemName, itemOrder);
            Response.Redirect(string.Format(redirectUrl, txtDlgRegionId));
            return View();
        }

        [ValidateInput(false)]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditTagItem (string txtDlgCurrentItemId, string txtDlgTagSize, string txtDlgItemId, string txtDlgCountryId, string txtDlgItemName, string txtDlgItemType) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            string redirectUrl = "/Admin/AddSightseeing?id={0}";
            if (txtDlgItemId != Constants.JSONNullElementValue)
                BizAdminTag.Update(int.Parse(txtDlgItemId), txtDlgItemName, int.Parse(txtDlgTagSize));
            else
                BizAdminTag.Add(txtDlgItemName, int.Parse(txtDlgCountryId), null, null, int.Parse(txtDlgCurrentItemId), null);
            Response.Redirect(string.Format(redirectUrl, txtDlgCurrentItemId));
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountryList (string ddlCountryEdt, string ddlDistrictEdt, string ddlCityEdt
                                                    , string txtCountryName, string txtDistrictName, string txtCityName
                                                    , string btnAddCountry, string btnAddDistrict, string btnAddCity
                                                    , string btnDeleteCountry, string btnDeleteDistrict, string btnDeleteCity) {
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            if (!CheckIsLogon(this.Session))
                Response.Redirect("/Admin/Login");
            if (!string.IsNullOrEmpty(btnAddCity))
                if (string.IsNullOrEmpty(txtCityName))
                    AddValidationMessage("Введите название города.", txtCityName);
                else
                    BizAdminCountry.AddCity(int.Parse(ddlDistrictEdt), int.Parse(ddlCountryEdt), txtCityName);
            if (!string.IsNullOrEmpty(btnAddCountry))
                if (string.IsNullOrEmpty(txtCountryName))
                    AddValidationMessage("Введите название страны.", txtCountryName);
                else
                    BizAdminCountry.AddCountry(txtCountryName);
            if (!string.IsNullOrEmpty(btnAddDistrict))
                if (string.IsNullOrEmpty(txtDistrictName))
                    AddValidationMessage("Введите название региона.", txtDistrictName);
                else
                    BizAdminRegion.Add(int.Parse(ddlCountryEdt), txtDistrictName);

            try {
                if (!string.IsNullOrEmpty(btnDeleteCity))
                    BizAdminCountry.DeleteCity(int.Parse(ddlCityEdt));
            } catch {
                AddValidationMessage("Для удаления города удалите все связанные с ним отели.", "ddlCityEdt");
            }
            try {
                if (!string.IsNullOrEmpty(btnDeleteCountry))
                    BizAdminCountry.DeleteCountry(int.Parse(ddlCountryEdt));
            } catch {
                AddValidationMessage("Для удаления страны удалите все связанные с ней отели.", "ddlCountryEdt");
            }
            try {
                if (!string.IsNullOrEmpty(btnDeleteDistrict))
                    BizAdminRegion.Delete(int.Parse(ddlDistrictEdt));
            } catch {
                AddValidationMessage("Для удаления региона удалите все связанные с ним отели.", "ddlDistrictEdt");
            }
            BindCountryDdl();
            return View();
        }

        private string GetDictionaryItemPage (string itemType) {
            switch (itemType) {
                case Constants.DictionaryItemSightseeing:
                    return Constants.DictionaryPageSightseeingTypeList;
                case Constants.DictionaryItemCountry:
                    return Constants.DictionaryPageCountryList;
                case Constants.DictionaryItemDistrict:
                    return Constants.DictionaryPageDistrictList;
                case Constants.DictionaryItemCity:
                    return Constants.DictionaryPageCityList;
                case Constants.DictionaryItemCountryInfo:
                    return Constants.DictionaryPageCountryInfoList;
            }
            return string.Empty;
        }

        public string GetSightseeingImagesHTML (int id) {
            return SightseeingImageHelper.GetSightseeingImagesHTML(id, true);
        }

        public string GetRecreationImagesHTML (int id) {
            return SightseeingImageHelper.GetRecreationImagesHTML(id, true);
        }

        public string GetCityImagesHTML (int id) {
            return CityImageHelper.GetCityImagesHTML(id, true);
        }

        private void BindCountryDdl () {
            this.ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", null);
            this.ViewData["ddlDistrict"] = new SelectList(new List<SelectListItem>());
            this.ViewData["ddlCity"] = new SelectList(new List<SelectListItem>());
        }

        private void BindSpecialOffer (int id) {
            TblSpecialOffer itm = BizSpecialOffer.GetSpecialOfferById(id);
            ViewData["CountryId"] = itm.CountryId;
            ViewData["Description"] = itm.Description;
            ViewData["SpecialOfferId"] = itm.Id;
            ViewData["IsSpecOffer"] = itm.IsSpecialOffer;
            ViewData["IsReadyTour"] = itm.IsReadyTour.HasValue ? itm.IsReadyTour.Value : false;
            ViewData["IsOnTop"] = itm.IsOnTop.HasValue ? itm.IsOnTop : false;
            ViewData["LinkUrl"] = itm.LinkUrl;
            ViewData["Price"] = itm.Price.HasValue ? itm.Price.ToString() : string.Empty;
            ViewData["ShortDescription"] = itm.ShortDescription;
            ViewData["Title"] = itm.Title;
            ViewData["txtOrder"] = itm.SpecOfferOrder.HasValue ? itm.SpecOfferOrder.Value : 0;
            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData().ToList(), "Id", "Name", itm.CountryId.ToString());
        }

        private void BindSightseeingData (int? id) {
            TblSightseeing item = new TblSightseeing();
            if (id.HasValue) {
                item = BizSightseeing.GetSightseeingById(id.Value);
                ViewData["PageTitle"] = "Редактирование статьи. Страна, регион: ";
                ViewData["PageButtonTitle"] = "Сохранить изменения";
                BindSightseeingRegionData(BizTour.GetTourRegionList(item.Id), item.Id);
                ViewData["GridTags"] = GridTagListHelper.GetSightseeingGridHTML(item.Id);
                ViewData["DictionaryItemType"] = Constants.DictionaryItemSightseeing;
            } else {
                ViewData["PageTitle"] = "Добавление новой статьи";
                ViewData["PageButtonTitle"] = "Добавить статью";
            }
            ViewData["Id"] = id.HasValue ? item.Id : Constants.NullValueSelected;
            ViewData["Description"] = id.HasValue ? item.Description : string.Empty;
            ViewData["ShortDescription"] = id.HasValue ? item.ShortDescription : string.Empty;
            //ViewData["RegionId"] = id.HasValue? item.RegionId : Constants.NullValueSelected;

            ViewData["CountryId"] = id.HasValue ? item.CountryId : Constants.NullValueSelected;
            ViewData["Name"] = id.HasValue ? item.Name : string.Empty;
            ViewData["TypeId"] = id.HasValue ? item.SightseeingTypeId : Constants.NullValueSelected;

            ViewData["ddlCountry"] = new SelectList(DictionaryHelper.GetCountryListData().ToList(), "Id", "Name", id.HasValue ? item.CountryId : Constants.NoValueSelected);
            //ViewData["ddlDistrict"] = id.HasValue ? 
            //        new SelectList(DictionaryHelper.GetDistrictListData(item.CountryId.Value).ToList(), "Id", "Description", id.HasValue ? item.RegionId : Constants.NoValueSelected)
            //        : new SelectList(new List<SelectListItem>());
            this.ViewData["ddlDistrict"] = new SelectList(new List<SelectListItem>());
        }

        private void BindCountryData (int countryId) {
            TblCountry country = BizCountry.GetCountryById(countryId);
            ViewData["DictionaryItemType"] = Constants.DictionaryItemCountryInfo;
            ViewData["CountryName"] = country.Name;
            ViewData["AdditionalInfo"] = country.AdditionalInfo;
            ViewData["CountryId"] = country.Id;
            Session["CountryId"] = country.Id;
            ViewData["Description"] = country.Description;
            ViewData["VisaDescription"] = country.VisaInfo;
            ViewData["ddlCity"] = new SelectList(BizCity.GetCityListByCountryId(country.Id), "Id", "Name", Constants.NoValueSelected);
            TblCity cap = BizCity.GetCapitalCity(country.Id);
            if (cap != null)
                ViewData["CountryCapitalName"] = cap.Name;
        }

        private void BindCountryInfoList (int countryId) {
            ViewData["GridCountryInfoList"] = AdminHelpers.GridCountryInfoList.GetGridHTML(BizCountry.GetCountryInfoList(countryId));
        }

        private void BindSightseeingRegionData (List<TblRegion> regs, int sightseeingId) {
            if (regs.Count > 0)
                ViewData["CountryName"] = BizCountry.GetCountryById(regs[0].CountryId).Name;
            ViewData["SightseeingRegionNames"] = BizSightseeing.GetRegionNames(sightseeingId);
            Session["SightseeingRegionIds"] = regs;
        }

        private void BindRegionData (int id) {
            TblRegion reg = BizRegion.GetRegionById(id);
            TblCountry country = BizCountry.GetCountryById(reg.CountryId);
            ViewData["CountryId"] = country.Id;
            ViewData["CountryName"] = BizCountry.GetCountryById(reg.CountryId).Name;
            ViewData["RegionName"] = reg.Name;
            ViewData["RegionId"] = reg.Id;
            ViewData["Latitude"] = reg.Latitude;
            ViewData["Longitude"] = reg.Longitude;
            ViewData["Description"] = reg.Description;
            Session["RegionId"] = reg.Id;
        }

        private void BindCityData (int id) {
            TblCity city = BizCity.GetCityById(id);
            ViewData["ImgUploadCount"] = BizCity.GetPhotoCount(id);
            ViewData["CityName"] = city.Name;
            ViewData["IsBeach"] = city.IsBeach;
            ViewData["CityId"] = city.Id;
            ViewData["Description"] = city.Description;
            ViewData["CountryId"] = city.CountryId;
            ViewData["CountryName"] = BizCountry.GetCountryById(city.CountryId).Name;
            ViewData["RegionId"] = city.RegionId;
            ViewData["RegionName"] = BizRegion.GetRegionById(city.RegionId).Name;
            ViewData["Latitude"] = city.Latitude;
            ViewData["Longitude"] = city.Longitude;
            Session["CityId"] = city.Id;
        }

        private void BindTourRegionData (List<TblRegion> regs) {
            if (regs.Count > 0)
                ViewData["CountryName"] = BizCountry.GetCountryById(regs[0].CountryId).Name;

            StringBuilder sb = new StringBuilder();
            foreach (TblRegion itm in regs)
                sb.Append(string.Format("{0}, ", itm.Name));
            if (sb.Length > 0)
                ViewData["TourRegionNames"] = sb.ToString().Substring(0, sb.Length - 2);
            Session["RegionIds"] = regs;
        }

        private TblTour BindTourData (int id) {
            TblTour tour = BizTour.GetTourById(id);
            ViewData["TourName"] = tour.Name;
            if (tour.Price.HasValue)
                ViewData["TourPrice"] = tour.Price;
            ViewData["TourProgram"] = tour.ProgramDescription;
            ViewData["TourId"] = tour.Id;
            ViewData["TourDays"] = tour.Days;
            ViewData["TourPopularity"] = tour.Popularity;
            ViewData["TourDescription"] = tour.Description;
            ViewData["TourIsSpecialOffer"] = tour.IsSpecialOffer.HasValue ? tour.IsSpecialOffer : false;
            ViewData["IsReadyTour"] = tour.IsReadyTour.HasValue ? tour.IsReadyTour : false;
            ViewData["TourSpecialOfferOrder"] = tour.SpecialOfferOrder;
            Session["TourId"] = tour.Id;
            return tour;
        }

        public ActionResult Login () {
            return View();
        }

        [HttpPost]
        public ActionResult Login (string txtUserName, string txtPassword) {
            if (ModelState.IsValid) {
                if (BizUser.CheckUserPassword(txtUserName, txtPassword)) {
                    TblUser user = BizUser.GetUser(txtUserName.TrimEnd());
                    Session["UserData"] = user;
                    Session["UserId"] = user.Id;
                    Session["UserRole"] = user.RoleId;
                    Response.Redirect("/Admin/Index");
                } else {
                    ModelState.AddModelError("", "Имя пользователя или пароль указаны неверно.");
                }
            }
            return View();
        }

        public ActionResult LogOff () {
            Session["UserData"] = null;
            return RedirectToAction("Login", "Admin");
        }

        public bool CheckIsLogon (HttpSessionStateBase session) {
            if (session["UserData"] == null)
                return false;
            return true;
        }

        private bool ValidateCountryInfo (string title, string description, string pageOrder) {
            try {
                int order = int.Parse(pageOrder);
            } catch {
                ModelState.AddModelError("txtpageorder", "Укажите порядок (целое число).");
            }
            if (string.IsNullOrEmpty(title)) {
                ModelState.AddModelError("txtTitle", "Введите название.");
            }
            if (string.IsNullOrEmpty(description)) {
                ModelState.AddModelError("txtDescription", "Введите содержание.");
                return false;
            }
            return ModelState.IsValid;
        }

        private bool ValidateSpecialOffer (string txtTitle, string txtShortDescription, string txtPrice, string txtLinkUrl) {
            if (string.IsNullOrEmpty(txtTitle)) {
                ModelState.AddModelError("txtTitle", "Введите название.");
            }
            if (string.IsNullOrEmpty(txtShortDescription)) {
                ModelState.AddModelError("txtShortDescription", "Введите описание.");
            }
            if (string.IsNullOrEmpty(txtPrice)) {
                ModelState.AddModelError("txtPrice", "Введите цену.");
            } else {
                try { float.Parse(txtPrice); } catch { ModelState.AddModelError("txtPrice", "Неверно введена цена."); }
            }
            if (string.IsNullOrEmpty(txtLinkUrl)) {
                ModelState.AddModelError("txtLinkUrl", "Введите ссылку.");
            }
            return ModelState.IsValid;
        }

        private bool ValidateTour (string name, string ddlCountry, string[] ddlRegion) {
            if (string.IsNullOrEmpty(name)) {
                ModelState.AddModelError("name", "Введите название.");
                return false;
            }
            try {
                int countryId = int.Parse(ddlCountry);
                if (countryId == Constants.NoValueSelected)
                    ModelState.AddModelError("name", "Укажите страну.");
            } catch {
                ModelState.AddModelError("name", "Укажите страну.");
            }
            try {
                //int regionId = int.Parse(ddlRegion);
                if (ddlRegion.Count() == 0)
                    ModelState.AddModelError("name", "Укажите регион.");
            } catch {
                ModelState.AddModelError("name", "Укажите регион.");
            }
            return ModelState.IsValid;
        }

        private void AddValidationMessage (string message, string controlName) {
            ModelState.AddModelError(controlName, message);
        }
    }
}
