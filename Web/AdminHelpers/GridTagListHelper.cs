using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridTagListHelper {
        public static string GetSightseeingGridHTML (int sightseeingId) {
            StringBuilder sb = new StringBuilder();
            List<TblTag> list = BizTag.GetTagsSightseeing(sightseeingId);
            sb.Append(GridBasicListHelper.GetHeader("Размер шрифта"));
            foreach (TblTag itm in list) {
                sb.Append(GridBasicListHelper.GetFormattedRow(itm.Id.ToString(), itm.Name, itm.TextSize.ToString(), Constants.DictionaryItemTag));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}