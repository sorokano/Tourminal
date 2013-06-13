using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridRegionRecreationListHelper {
        public static string GetGridHTML (List<TblRegionRecreation> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader("Приоритет"));
            foreach (TblRegionRecreation itm in items) {
                sb.Append(GridBasicListHelper.GetFormattedRow(itm.Id.ToString(), itm.Name, itm.ItemOrder.HasValue ? itm.ItemOrder.ToString() : "0"
                    , Constants.DictionaryItemRegionRecreation, true));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}