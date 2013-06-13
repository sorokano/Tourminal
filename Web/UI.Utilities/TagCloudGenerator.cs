using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;

namespace Elcondor.UI.Utilities {
    public static class TagCloudGenerator {
        public static string GetRandomTagCloud (int countryId) {
            StringBuilder sb = new StringBuilder();
            List<string> tagNames = BizTag.GetRandomTagNamesList(countryId, 10);
            //List<TblTag> tags = BizTag.GetRandomTagList(countryId, 10);
            foreach (string tagName in tagNames) {
                TblTag tag = BizTag.GetTagByName(tagName);
                TblRegion region = null;
                if (tag.RegionId.HasValue)
                    region = BizRegion.GetRegionById(tag.RegionId.Value);
                sb.Append(string.Format("{{ text: \"{0}\", weight: {1}, link: \"../../ViewByTag?tag={0}&countryId={2}&regionId={3}\" }},", tagName, tag.TextSize, countryId, region == null ? string.Empty : region.Id.ToString()));
            }

            return sb.ToString();
        }
    }
}