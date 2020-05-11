namespace sap.cap.invoice.try;

using {
    cuid,
    managed
} from '@sap/cds/common';
using {sap.cap.invoice.try} from './common';

type InvoiceAmount {
    FormatAmount : String;
    NumberAmount : try.Amount;
}

entity Invoice : cuid, managed {
        InvoiceID    : String;
    key InvoiceNo    : String;
        BillingDate  : Date;
        CheckCode    : String;
        MachineCode  : String;
        Purchaser    : Association to Purchasers;
        PasswordArea : LargeString;

        Items        : Composition of many InvoiceItems
                           on Items.Parent = $self;
        TotalAmount  : InvoiceAmount;
        Seller       : Association to Sellers;
        Comments     : LargeString;
        IsCreated    : Boolean default false;
        Payee        : String(255);
        Review       : String(255);
        IssuedBy     : String(255);
        SellerSeal   : LargeBinary;
}

entity Purchasers : cuid {
    Invoices       : Association to many Invoice
                         on Invoices.Purchaser = $self;

    Name           : String(255);
    TaxpayerIdenti : String;
    Address        : String;
    Phone          : String;
    OpenBank       : String;
    BankAccount    : String;
}


entity InvoiceItems : cuid {
    Parent    : Association to Invoice;
    TaxName   : String;
    Type      : String;
    Unit      : String;
    Quantity  : Integer;
    UnitPrice : Decimal(10, 2);
    Price     : Decimal(10, 2);
    TaxRate   : Decimal(10, 2);
    TaxAmount : Decimal(10, 2);
}

entity Sellers : cuid {
    Invoices       : Association to many Invoice
                         on Invoices.Seller = $self;

    Name           : String(255);
    TaxpayerIdenti : String;
    Address        : String;
    Phone          : String;
    OpenBank       : String;
    BankAccount    : String;
}
