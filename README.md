## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

[![Deploy to Salesforce](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=eduardoamiens&repo=AssessmentProject&ref=main)


 ## POST Deployment steps

 Execute the next into developer console

 String cronExpression = '0 0 0 * * ?';
 System.schedule('Daily Overdue Orders Check', cronExpression, new OverdueOrdersScheduler());
 System.schedule('Daily ProductSync Check', cronExpression, new ProductSyncBatchScheduler());
 

