using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridSightseeingTypeList {
        public static string GetGridHTML (List<TblSightseeingType> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader());
            foreach (TblSightseeingType itm in items) {
                sb.Append(GridBasicListHelper.GetFormattedRow(itm.Id.ToString(), itm.Description, string.Empty, Constants.DictionaryItemSightseeing));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}