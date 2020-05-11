using {sap.cap.invoice.try} from '../db/schema';


service InvoiceService {
    entity TheInvoice      as projection on try.Invoice;
    entity TheInvoiceItems as projection on try.InvoiceItems;
    entity ThePurchasers   as projection on try.Purchasers;
    entity TheSellers      as projection on try.Sellers;
}
