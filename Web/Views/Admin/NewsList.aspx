<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Новости и спецпредложения
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Данные будут удалены без возможности восстановления!")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteNews",
                        data: "imageId=" + itemId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                }
            });
			$(".img-delete-tour").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var tourImgAlt = $(this).attr("alt");
                    var tourId = tourImgAlt.substring(8, tourImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveTour",
                        data: "id=" + tourId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                                alert(msg);
                            }
                            location.reload();
                        }
                    });
                }
            });
            $(".img-delete-specoffer").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var tourImgAlt = $(this).attr("alt");
                    var tourId = tourImgAlt.substring(8, tourImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveSpecialOffer",
                        data: "id=" + tourId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                                alert(msg);
                            }
                            location.reload();
                        }
                    });
                }
            });

            $(".img-edit").click(function (e) {
                var tourImgAlt = $(this).attr("alt");
                var tourId = tourImgAlt.substring(14, tourImgAlt.length);
                document.location = "TourEdit?id=" + tourId;
            });
			//
			$(".img-edit-specoffer").click(function (e) {
                var tourImgAlt = $(this).attr("alt");
                var tourId = tourImgAlt.substring(14, tourImgAlt.length);
                document.location = "EditSpecialOffer?id=" + tourId;
            });
//            $("#dialog-edititem").dialog({
//                autoOpen: false,
//                height: 300,
//                width: 500,
//                modal: true,
//                title: 'Редактирование',
//                buttons: {
//                    'Закрыть': function () {
//                        $(this).dialog('close');
//                    }
//                },
//                close: function () { }
//            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a><br />
    <h2>Список Новостей</h2>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddNews" id="hrefAddItem">Добавить новость</a>
    <%= ViewData["GridPageList"] %>
	
	<br/><br/>

	<h2>Список Cпецпредложений</h2>
    Внимание! Чтобы ГЛАВНОЕ СПЕЦПРЕДЛОЖЕНИЕ появилось вверху Главной страницы сайта, необходимо убедиться, что оно единственное в списке!
    <br />
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddTour" id="hrefAddItem">Добавить тур</a>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddExcurs" id="A1">Добавить экскурсию</a>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddSpecialOffer" id="A2">Добавить независимое предложение</a>
    <br />
	<%
		StringBuilder sb = new StringBuilder();
		int filterCountry = 0;
		sb.Append("<div id=\"admin-list\">");
		sb.Append("<table border=\"1px\" width=\"700px\" class=\"grid-common\">");
		sb.Append("    <theader>");
		sb.Append("    <tr style=\"font-weight: bold;text-align: center;\">");
		sb.Append("        <td width=\"20px\">");
		sb.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=1&filterCountry={1}' class='sort-column'>{0}</a>"
															 : "<a href='?sortBy=1' class='sort-column'>{0}</a>", "№", filterCountry));
		sb.Append("        </td>");
		sb.Append("        <td width=\"150px\">");
		sb.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=2&filterCountry={1}' class='sort-column'>{0}</a>"
															 : "<a href='?sortBy=2' class='sort-column'>{0}</a>", "Название", filterCountry));
		sb.Append("        </td>");
		sb.Append("        <td width=\"250px\">");
		sb.Append("Страна, регион");
		sb.Append("        </td>");
		sb.Append("        <td width=\"10px\" style=\"text-align: center\">");
		sb.Append("        ");
		sb.Append("        </td>");
		sb.Append("        <td width=\"10px\" style=\"text-align: center\">");
		sb.Append("        ");
		sb.Append("        </td>");
		sb.Append("    </tr>");
		sb.Append("    </theader>");
		List<LinqToElcondor.TblTour> list = ElcondorBiz.BizTour.GetTourListByCountryId(null);
		List<LinqToElcondor.TblTour> offers = ElcondorBiz.BizTour.GetSpecialOfferReadyTourList();
		//List<LinqToElcondor.TblSpecialOffer> offers2 = ElcondorBiz.BizSpecialOffer.GetSpecialOfferReadyToursList();`
		LinqToElcondor.ElcondorDBDataContext db = new LinqToElcondor.ElcondorDBDataContext();
		List<LinqToElcondor.TblSpecialOffer> offers2 = new List<LinqToElcondor.TblSpecialOffer>();
		var so = from k in db.TblSpecialOffer
				 //where k.IsSpecialOffer == true
				 orderby k.SpecOfferOrder descending 
				 select k;

		foreach (LinqToElcondor.TblSpecialOffer p in so.ToList()) {
			LinqToElcondor.TblSpecialOffer tbl = new LinqToElcondor.TblSpecialOffer();
			tbl.Description = p.Description;
			tbl.Title = p.Title;
			tbl.Id = p.Id;
			tbl.ShortDescription = p.ShortDescription;
			tbl.Price = p.Price;
			tbl.LinkUrl = p.LinkUrl;
			tbl.IsOnTop = p.IsOnTop;
			tbl.Image = p.Image;
			tbl.CountryId = p.CountryId;
			tbl.IsSpecialOffer = p.IsSpecialOffer;
			tbl.SpecOfferOrder = p.SpecOfferOrder;
			offers2.Add(tbl);
		}
            
		
		foreach (LinqToElcondor.TblTour item in offers) {
			StringBuilder regCountryNames = new StringBuilder();
			List<LinqToElcondor.TblRegion> regList = new List<LinqToElcondor.TblRegion>();
			try {
				regList = ElcondorBiz.BizTour.GetTourRegionList(item.Id);
				if (regList.Count > 0) {
					try {
						regCountryNames.Append(string.Format("{0}: ", ElcondorBiz.BizCountry.GetCountryById(regList[0].CountryId).Name));
						foreach (LinqToElcondor.TblRegion reg in regList) {
							if (reg != null)
								regCountryNames.Append(string.Format("{0}, ", reg.Name));
						}
					} catch {}
				}
			} catch {}
			string countryRegNames = regCountryNames.Length > 0 ? regCountryNames.ToString().Substring(0, regCountryNames.Length - 2) : "Все";
			string id = item.Id.ToString();
			string name = item.Name;
			sb.Append("<tr class=\"row-itemlist\">");
            sb.Append("<td>");
            sb.Append(string.Format("<a href=\"/Admin/TourEdit?id={0}\">{0}</a>", id));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format("<a href=\"/Admin/TourEdit?id={0}\">{1}</a>", id, name));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(countryRegNames);
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format(
                        "<img src=\"../../Content/images/grid-edit.gif\" id=\"{0}\" alt=\"Редактировать {0}\" name=\"{1}\" class=\"img-edit\" />"
                                                , id, name));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format(
                        "<img src=\"../../Content/images/grid-delete.gif\" id=\"{0}\" alt=\"Удалить {0}\" name=\"{1}\" class=\"img-delete-tour\" />"
                                                , id, name));
            sb.Append("</td>");
            sb.Append("</tr>");
		}
		//
		foreach (LinqToElcondor.TblSpecialOffer item2 in offers2) {
			string id = item2.Id.ToString();
			string name = string.IsNullOrEmpty(item2.Title) ? "" : item2.Title;
			sb.Append("<tr class=\"row-itemlist\">");
            sb.Append("<td>");
            sb.Append(string.Format("<a href=\"/Admin/EditSpecialOffer?id={0}\">{0}</a>", id));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format("<a href=\"/Admin/EditSpecialOffer?id={0}\">{1}</a>", id, name));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("");
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format(
                        "<img src=\"../../Content/images/grid-edit.gif\" id=\"{0}\" alt=\"Редактировать {0}\" name=\"{1}\" class=\"img-edit-specoffer\" />"
                                                , id, name));
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append(string.Format(
                        "<img src=\"../../Content/images/grid-delete.gif\" id=\"{0}\" alt=\"Удалить {0}\" name=\"{1}\" class=\"img-delete-specoffer\" />"
                                                , id, name));
            sb.Append("</td>");
            sb.Append("</tr>");
		}
		sb.Append("</table>");
		sb.Append("</div>");
	%>
	<%= sb.ToString() %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>

    <%--<div id="dialog-edititem">
        <% using (Html.BeginForm("EditModulePageItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <table width=100%>
                <tr>
                    <td>Порядок :</td><td><%= Html.TextBox("txtOrder", string.Empty, new { style = "width:100px" })%><br /></td>
                </tr>
                <tr>
                    <td>Заголовок:</td><td width="250px"> <%= Html.TextBox("txtTitle", string.Empty, new { style = "width:250px" })%></td>
                </tr>
                <tr>
                    <td>Содержание:</td><td width="250px"> <%= Html.TextBox("txtDescr", string.Empty, new { style = "width:250px" })%></td>
                </tr>
            </table>
            <br />
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" style=:float:right;margin-right:10px;" />
        <% } %>
        <br />
    </div>--%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
