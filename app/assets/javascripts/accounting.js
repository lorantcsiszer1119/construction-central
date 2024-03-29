var calculatePurchaseAmount = function (obj, f){
    var estimateCost = $(obj).closest("tr").find('input[name="items[][estimated_cost]"]');
    var qty = $(obj).closest("tr").find('input[name="items[][qty]"]');
    var eValue = text_to_number($(estimateCost).val());
    var qValue = text_to_number(qty.val());
    var pValue = eValue * qValue;
    var placeHolder = $(obj).closest("tr").find(".actual-amount-placeholder");
    if (placeHolder.find(".actual-amount").size() > 0) {
        placeHolder.find(".actual-amount").text(number_to_currency_with_unit(pValue, 2, '.', ','));
    } else {
        placeHolder.prepend('<div class="actual-amount">' + number_to_currency_with_unit(pValue, 2, '.', ',') + '</div>');
    }
    calculatePostTaxAmount($(placeHolder).find(".actual-amount"));
};

var calculateSubTotalAndTotal = function () {
    if ($("#total").size() > 0) {
        var subtotal = 0;
        $('.actual-amount').each(function () {
            subtotal += text_to_number($(this).text());
        });
        $('#subtotal').html(subtotal == 0 ? "" : number_to_currency_with_unit(subtotal, 2, '.', ','));
        var total = subtotal;
        if ($('input[name$="[sales_tax_rate]"]').size() > 0) {
            var salesTax = subtotal * text_to_number($('input[name$="[sales_tax_rate]"]').val()) / 100;
            $('#sales_tax').html(salesTax == 0 ? "" : number_to_currency_with_unit(salesTax, 2, '.', ','));
            total += salesTax;
        }
        if ($('input[name$="[shipping]"]').size() > 0) {
            var shipping = text_to_number($('input[name$="[shipping]"]').val());
            total += shipping;
        }
        $('#total').html(total == 0 ? "" : number_to_currency_with_unit(total, 2, '.', ','));
    }
};

var calculatePayment = function(){
    if ($("#payment-amount").size() > 0) {
        var total = 0;
        $('input[name="bill-chosen"]:checked').each(function () {
            total += text_to_number($(this).closest("tr").find('input[name="payment[payments_bills_attributes][][paid_amount]"]').val());
        });
        $('#payment-amount').html(total == 0 ? "" : number_to_currency_with_unit(total, 2, '.', ','));
    }
}

var calculatePostTaxAmount = function (i) {
    var actualAmount = text_to_number($(i).text());
    if ($('input[name$="[sales_tax_rate]"]').size() > 0) {
        actualAmount *= (1 + text_to_number($('input[name$="[sales_tax_rate]"]').val()) / 100);
        $(i).closest("tr").find(".post-tax-actual-amount").text(number_to_currency_with_unit(actualAmount, 2, '.', ','))
    }
    $(i).closest("tr").find('input[name="items[][actual_cost]"]').val(actualAmount.toFixed(2));
}

var calculatePostTaxAmounts = function () {
    $('.actual-amount').each(function () {
        calculatePostTaxAmount(this);
    });
}

var toggleItemInputs = function (checbox, s) {
    $(checbox).closest("tr").find('.text-field').toggle(s);
    $(checbox).closest("tr").find('.value-field').toggle(!s);
};

$(document).ready(function() {
    $("#payables .scrollable").tableScroll({height:137});

    calculatePostTaxAmounts();
    calculateSubTotalAndTotal();
    calculatePayment();

    $(document).on('change', 'input[name="items[][qty]"], input[name="items[][estimated_cost]"]', function () {
        calculatePurchaseAmount(this);
        calculateSubTotalAndTotal();
    });
    $(document).on('change', 'input[name="item-chosen"]', function () {
        if ($(this).is(":checked")) {
            toggleItemInputs(this, true);
            calculatePurchaseAmount(this);
        } else {
            toggleItemInputs(this, false);
            $(this).closest("tr").find(".actual-amount-placeholder").text("");
            $(this).closest("tr").find('input[name="items[][actual_cost]"]').val("");
        }
        calculateSubTotalAndTotal();
    });
    $(document).on('change', "select#purchased_item_id", function () {
        var link = $("a#add-purchased-item").attr("href");
        $("a#add-purchased-item").attr("href", updateQueryStringParameter(link, "item_id", $(this).val()));
    });
    $(document).on('click', '.purchasable-list a.remove-item', function (e) {
        e.preventDefault();
        $(this).closest("tr").remove();
        calculateSubTotalAndTotal();
        return false;
    });
    $(document).on('change', 'input[name$="[shipping]"] ', function () {
        calculateSubTotalAndTotal();
    });
    $(document).on('change', 'input[name$="[sales_tax_rate]"]', function () {
        calculatePostTaxAmounts();
        calculateSubTotalAndTotal();
    });
    $(document).on('change', 'input[name="bill-chosen"]', function () {
        if ($(this).is(":checked")) {
            toggleItemInputs(this,true);
            $(this).closest("tr").find('input[name="payment[payments_bills_attributes][][_destroy]"]').val("false");
        } else {
            toggleItemInputs(this,false);
            $(this).closest("tr").find('input[name="payment[payments_bills_attributes][][_destroy]"]').val("true");
        }
        calculatePayment();
    });
    $(document).on('change', 'input[name="payment[payments_bills_attributes][][paid_amount]"] ', function () {
        calculatePayment();
    });

})