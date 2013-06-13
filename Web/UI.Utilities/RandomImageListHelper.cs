using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;

namespace Elcondor.UI.Utilities {
    public static class RandomImageListHelper {
        public static string GetRandomImageListHTML (int countryId) {
            StringBuilder sb = new StringBuilder();
            List<TblPhotoImage> items = BizImage.GetRandomCountryPhotoImageList(countryId, 6);
            if (items.Count > 0) {
                sb.Append("<ul id=\"list-random-img\">");
                foreach (TblPhotoImage img in items) {
                    TblPhotoalbum alb = BizPhotoalbum.GetPhotoalbumById(img.PhotoalbumId);
                    int photoOrder = 0;
                    if (alb.CityId.HasValue) {
                        foreach (TblPhotoImage ctyimg in BizCity.GetCityImageGallery(alb.CityId.Value)) {
                            if (ctyimg.Id == img.Id) {
                                break;
                            }
                            photoOrder++;
                        }
                        sb.Append(string.Format("<li><a href=\"../../CityAbout?id={0}&i={3}#!prettyPhoto[pp_gal]/{3}/\"><img src=\"/Content/UserImages/album_{1}_image_{2}.jpg\"></a></li>", alb.CityId.Value, img.PhotoalbumId, img.Id, photoOrder));
                    }
                    if (alb.SightseeingId.HasValue) {
                        foreach (TblPhotoImage sghtimg in BizSightseeing.GetSightseeingImageGallery(alb.SightseeingId.Value)) {
                            photoOrder++;
                            if (sghtimg.Id == img.Id) {
                                break;
                            }
                        }
                        sb.Append(string.Format("<li><a href=\"../../ViewArticle?id={0}&i={3}#!prettyPhoto[pp_gal]/{3}/\"><img src=\"/Content/UserImages/album_{1}_image_{2}.jpg\"></a></li>", alb.SightseeingId.Value, img.PhotoalbumId, img.Id, photoOrder));
                    }
                }
                sb.Append("</ul>");
            }
            return sb.ToString();
        }
    }
}