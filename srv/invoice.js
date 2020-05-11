const cds = require("@sap/cds");
/**
* @param {import("@sap/cds/apis/services").Service} srv
*/

module.exports = (srv) => {
    const { TheInvoice: InvoiceTable, ThePurchasers: PurchaserTable, TheSellers: SellerTable } = srv.entities;

    /**
    * reuseable functions
    */
    const purchasers = () => cds.run( // convert query to promise
        SELECT.from(PurchaserTable) // query definition
    );
    const sellers = () => cds.run( // convert query to promise
        SELECT.from(SellerTable) // query definition
    );
    const invoices = (invoiceNo = "") => cds.run(
        SELECT.from(InvoiceTable).where({ "InvoiceNo": invoiceNo })
    );
    let currKey = "";
    let creating = false;
    const updateInvoice = (invoiceNo = "") => cds.run(
        UPDATE(InvoiceTable).set({ "IsCreated": true }).where({ "InvoiceNo": invoiceNo })
    );


    srv.before("CREATE", InvoiceTable, async ctx => {
        // firstly judge whether the Purchasers and Sellers are exist
        const PurchaseCount = await purchasers().catch(err => { throw new Error(err); });
        const SellerCount = await sellers().catch(err => { throw new Error(err); });
        if (PurchaseCount < 1 || SellerCount < 1) {
            throw new Error("Please ensure the Purchaser and Seller have data!");
        }
        creating = true;
    })


    srv.on("COMMIT", InvoiceTable, ctx => {
        // judge whether is creating invoice
        if (creating == true) {
            currKey = ctx.data.InvoiceNo;
        }
    })

    srv.after("COMMIT", InvoiceTable, async () => {
        // judge whether is creating invoice
        if (creating == true) {
            const currInvoice = await invoices(currKey).catch(err => { throw new Error(err); });
            if (currInvoice < 1) {
                throw new Error("Can't find the invoice just created!");
            }

            const invoiceUpdate = await updateInvoice(currKey).catch(err => { throw new Error(err); });
            if (invoiceUpdate != 1) {
                throw new Error("Update failed!");
            }
            creating = false;
        }
    })

}