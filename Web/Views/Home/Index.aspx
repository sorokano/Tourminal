<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Турминал - туроператор в Санкт-Петербурге
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="width: 670px;padding-left:0px;margin-left: 0;margin-top:5px;">
        <div class="special_offers wrapper relover">
		    <%--<h2>Наши спецпредложения</h2>--%>
		    <div style="width:670px;display:block;margin-left:-30px;">
			    <%--<button class="prev"></button>--%>
			    <div class="slider">
                    <%  var of1 = ElcondorBiz.BizTour.GetSpecialOfferList().ToList();
						of1.OrderBy(item => item.SpecialOfferOrder);
						List<LinqToElcondor.TblTour> offers = of1.ToList();						
						var of2 = ElcondorBiz.BizSpecialOffer.GetSpecialOfferList().ToList();
						of2.OrderBy(item => item.SpecOfferOrder);
						List<LinqToElcondor.TblSpecialOffer> offers2 = of2.ToList();
						int totalCount = offers.Count + offers2.Count;
                        if (totalCount == 0) {%>
                            <span class="mainTitle">
                                <h1 style="color:#3b2314;margin-top: 150px;"><u>Специальных предложений нет.</u></h1>
                            </span>
                        <% } else {%>
                            <ul class="special_slider_list">
                            <%  StringBuilder sb1 = new StringBuilder();
                                int cnter = 0;
                                foreach (LinqToElcondor.TblSpecialOffer item in offers2.ToList()) {
                                    if (cnter >= 12)
                                        break;
                                    sb1.Append(string.Format("<li><div>"));
                                    sb1.Append(string.Format("<a class=\"special_slider_link\" href=\"{0}\"><figure>", item.LinkUrl));
                                    bool hasImage = false;
                                    try { hasImage = item.Image.Length > 0; } catch { hasImage = false; }
                                    if (hasImage) {
                                        sb1.Append(
                                            string.Format(
                                            "<img src=\"../../Content/UserImages/specialoffer_th_{0}.jpg\"  alt=\"\" width=\"200\" height=\"180\" />", item.Id));
                                    }
                                    sb1.Append(string.Format("<figcaption><b>{1}</b>{0}</figcaption></figure>",  item.Title, ""));

                                    sb1.Append(string.Format("<span class=\"slider_price relover\"><span class=\"slider_price_l\"></span>"));
                                    sb1.Append(string.Format("<span class=\"slider_price_c\">{0}</span><span class=\"slider_price_r\"></span>", item.Price.ToString() == "0" ? "Подробнее" : "от " + item.Price.ToString() + "руб."));
                                    sb1.Append("</span></a>");
                                    sb1.Append("</div>");
                                    sb1.Append("</li>");
                                    cnter++;
                                }
                                foreach (LinqToElcondor.TblTour item in offers) {
                                    if (cnter == 4) {
                                        //sb1.Append(" </ul><ul class=\"special_slider_list>\"");
                                    
                                    }
                                    if (cnter >= 12)
                                        break;
                                    cnter++;
                                    sb1.Append(string.Format("<li><div>"));
                                    sb1.Append(string.Format("<a class=\"special_slider_link\" href=\"../../ViewTour?id={0}\"><figure>", item.Id));
                                    bool hasImage = false;                                
                                    try { hasImage = item.ThumbImage.Length > 0; } catch { hasImage = false; }
                                    if (hasImage) {
                                        sb1.Append(
                                            string.Format(
                                            "<img src=\"../../Content/UserImages/tour_th_{0}.jpg\"  alt=\"\" width=\"200\" height=\"180\" />", item.Id));
                                    }
                                    sb1.Append(string.Format("<figcaption><b>{1}</b>{0}</figcaption></figure>", item.Name, ""));
                                
                                    sb1.Append(string.Format("<span class=\"slider_price relover\"><span class=\"slider_price_l\"></span>"));
                                    sb1.Append(string.Format("<span class=\"slider_price_c\">{0}</span><span class=\"slider_price_r\"></span>", item.Price.ToString() == "0" ? "Подробнее" : "от " + item.Price.ToString() + "руб."));
                                    sb1.Append("</span></a>");
                                    sb1.Append("</div>");
                                    sb1.Append("</li>");
                                }
                                %>
                                <%= sb1.ToString()%>
                        </ul>   
                        <% } %>  
                </div>  
                <%--<button class="next"></button>--%>
            </div> 
            <a href="../../SpecialOffers" class="all_offers">Посмотреть все предложения</a>
	    </div>

        <% if (ElcondorBiz.BizNews.GetNewsList().Count > 0) { %>
        <div class="travel_notes relover">
            <div class="wrapper">
                <div class="travel_notes_h relover">
				    <h2>Новости</h2>
			    </div>
                <div class="g-block g-dotted-v g-clearfix">
		            <div class="b-news-column b-news-column-right">
			            <div class="g-wrap g-clearfix">
                            <%=  ViewData["NewsListHTML"]%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
        
    </div>
    
    
    <%--<div class="colMain">--%>
    
    <%--</div>--%>
    <%--<h2>Наши направления</h2>
    <div class="colMain">
        <%  List<LinqToElcondor.TblCountryAll> list = ElcondorBiz.BizDictionary.GetCountryAllInfo();
            LinqToElcondor.TblCountryAll allRow = new LinqToElcondor.TblCountryAll();
            StringBuilder sb = new StringBuilder();
            
            sb.Append("<div class=\"dir_cols relover\"><div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 0)) {
                if (index > 0) {
                    if (list[index].RegionName != list[index - 1].RegionName)
                        sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                } else {
                    sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                }
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\"> ", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div>");
            sb.Append("<div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 1)) {
                if (list[index].RegionName != list[index - 1].RegionName)
                    sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div>");
            sb.Append("<div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 2)) {
                if (list[index].RegionName != list[index - 1].RegionName)
                        sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div></div>");
            ViewData["CountryList"] = sb.ToString();
        %>
        <%= ViewData["CountryList"] %>
    </div>--%>
    <%--<div class="anchor"></div>--%>
</asp:Content>