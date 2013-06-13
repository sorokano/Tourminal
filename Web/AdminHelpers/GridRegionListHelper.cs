using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridRegionListHelper {
        public static string GetGridHTML (List<TblRegion> items, int countryId) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader("Кол-во городов"));
            foreach (TblRegion itm in items) {
                sb.Append(GridBasicListHelper.GetFormattedRow(itm.Id.ToString(), itm.Name, DictionaryHelper.GetCityListData(itm.Id).Count().ToString()
                    , Constants.DictionaryItemDistrict, string.Format("../../Admin/RegionEdit?id={0}", itm.Id)));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}