using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;

namespace Elcondor.AdminHelpers {
    public static class CityImageHelper {
        public static string GetCityImagesHTML (int cityId, bool isAdmin) {
            StringBuilder sb = new StringBuilder();
            List<TblPhotoImage> items = BizCity.GetCityImageGallery(cityId);
            foreach (TblPhotoImage item in items) {
                sb.Append(string.Format("<img src=\"/Content/UserImages/album_{0}_image_{1}.jpg\" />", item.PhotoalbumId, item.Id));
                sb.Append(string.Format("<br/>Описание (макс. 1000 символов): <textarea id=\"txtDesc{0}\" type=\"text\" style=\"width:500px\" name=\"txtDesc{0}\" rows=\"3\">{1}</textarea>", item.Id, item.Description));
                sb.Append(string.Format("<br /><input id=\"btnSaveImgDesc{0}\" onclick=\"return OnUpdateImageDesc({0});\" type=\"button\" value=\"Сохранить\"> &nbsp;", item.Id));
                if (isAdmin)
                    sb.Append(string.Format("<a href=\"#\" id=\"imgDelete{0}\" onclick=\"return OnDeleteCityImage({0});\">Удалить фото [X]</a>", item.Id));
                sb.Append("<br/><br/>");
            }

            return sb.ToString();
        }
    }
}