using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;

namespace Elcondor.AdminHelpers {
    public static class SightseeingImageHelper {
        public static string GetSightseeingImagesHTML (int sightseeingId, bool isAdmin) {
            StringBuilder sb = new StringBuilder();
            List<TblPhotoImage> items = BizSightseeing.GetSightseeingImageGallery(sightseeingId);
            foreach (TblPhotoImage item in items) {
                sb.Append(string.Format("<img src=\"/Content/UserImages/album_{0}_image_{1}.jpg\" />", item.PhotoalbumId, item.Id));
                //sb.Append(string.Format("Примечание: {0}", item.Description));
                if (isAdmin)
                    sb.Append(string.Format("<br /><a href=\"#\" id=\"imgDelete{0}\" onclick=\"return OnDeleteSightseeingImage({0});\">Удалить фото [X]</a>", item.Id));
                sb.Append("<br/><br/>");
            }

            return sb.ToString();
        }

        public static string GetRecreationImagesHTML (int recreationId, bool isAdmin) {
            StringBuilder sb = new StringBuilder();
            List<TblPhotoImage> items = BizRegionRecreation.GetRecreationImageGallery(recreationId);
            foreach (TblPhotoImage item in items) {
                sb.Append(string.Format("<img src=\"/Content/UserImages/recreation_{0}_image_{1}.jpg\" />", item.PhotoalbumId, item.Id));
                //sb.Append(string.Format("Примечание: {0}", item.Description));
                if (isAdmin)
                    sb.Append(string.Format("<br /><a href=\"#\" id=\"imgDelete{0}\" onclick=\"return OnDeleteRecreationImage({0});\">Удалить фото [X]</a>", item.Id));
                sb.Append("<br/><br/>");
            }

            return sb.ToString();
        }
    }
}