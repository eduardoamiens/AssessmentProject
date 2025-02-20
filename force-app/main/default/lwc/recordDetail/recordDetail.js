import { LightningElement, wire } from 'lwc'
import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext, MessageContext } from 'lightning/messageService'
import assessmentProjectMessageChannel from "@salesforce/messageChannel/assessmentProjectMessageChannel__c"
import getOrderItems from'@salesforce/apex/recordDetailController.getOrderItems'
import { deleteRecord } from 'lightning/uiRecordApi'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import ORDER_ITEM_OBJECT from '@salesforce/schema/Order_Item__c';
import PRODUCT_EXTERNAL from '@salesforce/schema/Order_Item__c.Product_External__c';
import ITEM_COUNT from '@salesforce/schema/Order_Item__c.Item_count__c';
import ORDER from '@salesforce/schema/Order_Item__c.Order__c';

export default class RecordDetail extends LightningElement {

    ORDER = ORDER
    PRODUCT_EXTERNAL = PRODUCT_EXTERNAL
    ITEM_COUNT = ITEM_COUNT

    subscription = null

    orderData

    isModalOpen

    get orderId(){
        return this.orderData?.Id

    }
    get customerId (){
        return this.orderData?.Customer__c
    }


    orderItems

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Price', fieldName: 'Product_price__c', type: 'currency' },
        { label: 'Item count', fieldName: 'Item_count__c' },
        { label: 'Price changed', fieldName: 'Price_changed__c' },{
            type: 'action',
            typeAttributes: {
                rowActions: [
                    { label: 'View Details', name: 'view_details' },
                    { label: 'Delete', name: 'delete' }
                ]
            }
        }
    ]


    @wire(MessageContext)
    messageContext

    connectedCallback(){
        this.subscribeToMessageChannel()
    }

    subscribeToMessageChannel(){
        this.subscription = subscribe(this.messageContext, assessmentProjectMessageChannel, (message) => {
            this.handleMessage(message)
        })
    }

    async handleMessage(message){
        console.log('message', message)
        this.orderData = message.messageToSend
        this.orderItems = await getOrderItems({orderId: this.orderData.Id})
        console.log('orderItems', this.orderItems)
    }

    handleCancel() {
        console.log('Cancel button clicked')
    }

    async loadOrderItems() {
        try {
            this.orderItems = await getOrderItems({ orderId: this.orderData.Id })
            console.log('orderItems', this.orderItems)
        } catch (error) {
            console.error('Error loading order items:', error)
        }
    }

    async deleteOrderItem(orderItemId) {
        try {
            await deleteRecord(orderItemId)
            this.showToast('Success', 'Order item deleted successfully', 'success')
            this.loadOrderItems()
        } catch (error) {
            console.error('Error deleting order item:', error)
            this.showToast('Error', 'Failed to delete order item', 'error')
        }
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        })
        this.dispatchEvent(event)
    }
    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
    handleError(event) {
        console.error('Save error:', JSON.stringify(event.detail));
    
        let errorMessage = 'Failed to save record. Please try again.';
    
        if (event.detail && event.detail.output && event.detail.output.errors) {
            let errors = event.detail.output.errors;
            if (errors.length > 0) {
                errorMessage = errors[0].message; // Captura el mensaje de validación de Salesforce
            }
        }
    
        this.showToast('Error', errorMessage, 'error');
    }
    handleSuccess() {
        this.showToast('Success', 'Order item added successfully', 'success');
        this.closeModal();
        this.loadOrderItems(); 
    }
}