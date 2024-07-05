class VisitorsModal {
    List<VisitorItem> data;

    VisitorsModal({
        required this.data,
    });

    factory VisitorsModal.fromJson(Map<String, dynamic> json) => VisitorsModal(
        data: List<VisitorItem>.from(json["data"].map((x) => VisitorItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VisitorItem {
    String? addressLine1;
    dynamic addressLine2;
    String? blockName;
    String? country;
    VisitorDetailsJson? detailsJson;
    DateTime? entryDate;
    String? name;
    String? securityCode;
    String? state;
    int? userId;
    int? visitStatus;
    int? visitorId;
    int? visitorType;

    VisitorItem({
        this.addressLine1,
        this.addressLine2,
        this.blockName,
        this.country,
        this.detailsJson,
        this.entryDate,
        this.name,
        this.securityCode,
        this.state,
        this.userId,
        this.visitStatus,
        this.visitorId,
        this.visitorType,
    });

    factory VisitorItem.fromJson(Map<String, dynamic> json) => VisitorItem(
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        blockName: json["block_name"],
        country: json["country"],
        detailsJson: json["details_json"] == null ? null : VisitorDetailsJson.fromJson(json["details_json"]),
        entryDate: json["entry_date"] == null ? null : DateTime.parse(json["entry_date"]),
        name: json["name"],
        securityCode: json["security_code"],
        state: json["state"],
        userId: json["user_id"],
        visitStatus: json["visit_status"],
        visitorId: json["visitor_id"],
        visitorType: json["visitor_type"],
    );

    Map<String, dynamic> toJson() => {
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "block_name": blockName,
        "country": country,
        "details_json": detailsJson?.toJson(),
        "entry_date": entryDate?.toIso8601String(),
        "name": name,
        "security_code": securityCode,
        "state": state,
        "user_id": userId,
        "visit_status": visitStatus,
        "visitor_id": visitorId,
        "visitor_type": visitorType,
    };
}

class VisitorDetailsJson {
    String? name;
    String? phoneNumber;
    String? cabNumber;

    VisitorDetailsJson({
        this.name,
        this.phoneNumber,
        this.cabNumber,
    });

    factory VisitorDetailsJson.fromJson(Map<String, dynamic> json) => VisitorDetailsJson(
        name: json["name"],
        phoneNumber: json["phone_number"],
        cabNumber: json["cab_number"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "cab_number": cabNumber,
    };
}
