import { LightningElement, wire } from 'lwc'
import getOrders from'@salesforce/apex/orderViewController.getOrders'
import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext, MessageContext } from 'lightning/messageService'
import assessmentProjectMessageChannel from "@salesforce/messageChannel/assessmentProjectMessageChannel__c"
import { refreshApex } from '@salesforce/apex'

export default class OrderView extends LightningElement {

    wiredOrdersResult
    ordersData = []

    columns = [
        { label: 'Order Number', fieldName: 'Name' },
        { label: 'Customer Name', fieldName: 'CustomerName' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Total Value', fieldName: 'Total__c', type: 'currency' },
        { label: 'Estimated Delivery Date', fieldName: 'Estimated_Delivery_Date__c', type: 'date' },
        {
            type: 'action',
            typeAttributes: {
                rowActions: [
                    { label: 'View Details', name: 'view_details' },
                    { label: 'Delete', name: 'delete' }
                ]
            }
        }
    ]

    myMessage

    loading = false

    context = createMessageContext()

    isModalOpen = false

    @wire(getOrders)
    async wiredOrders(result) {
        this.loading = true
        this.wiredOrdersResult = result
        if (await result.data) {
            this.ordersData = result.data.map(order => ({
                ...order,
                CustomerName: order.Customer__r ? order.Customer__r.Last_Name__c : 'N/A' 
            }))
        } else if (result.error) {
            console.error('Error al cargar órdenes:', result.error)
        }
        this.loading = false
    }

    /*async connectedCallback(){
        this.loading = true
        const orderData = await getOrders()
        if(orderData){
            this.ordersData = orderData.map(order => ({
                ...order,
                CustomerName: order.Customer__r ? order.Customer__r.Last_Name__c : 'N/A' 
            }))
        }
        console.log('this.ordersData', this.ordersData)
        console.log('this.ordersData' + JSON.stringify(this.ordersData))
        this.loading = false
    }*/

    @wire(MessageContext)
    messageContext

    // Manejo de eventos de acciones en cada fila
    handleRowAction(event) {
        console.log('rowAction')
        const actionName = event.detail.action.name
        const row = event.detail.row

        switch (actionName) {
            case 'view_details':
                this.viewDetails(row)
                break
            case 'delete':
                this.deleteOrder(row)
                break
            default:
                break
        }
    }

    viewDetails(order) {
        console.log('Ver detalles de:', order)
        const message = {
            messageToSend: order
        }
        publish(this.context, assessmentProjectMessageChannel, message)
    }

    deleteOrder(order) {
        console.log('Eliminar orden:', order)
        //alert(`Se eliminará la orden: ${order.Name}`)
    }

     handleNewOrder() {
        this.isModalOpen = true
    }

    closeModal() {
        this.isModalOpen = false
    }

    async handleSuccess() {
        this.closeModal()
        await refreshApex(this.wiredOrdersResult)
    }

}