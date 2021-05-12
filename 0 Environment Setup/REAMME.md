# Workshop Environment Setup Instructions

This section gives you guidance on how to setup the environment for the workshop, as follows:

> * Set up an Azure account.
> * Deploy the ARM template for the infrastructure including Azure VMs, vNet etc.
> * Confirm the environment setups 

## Prepare an Azure user account

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/pricing/free-trial/) before you begin.

Once your subscription is set up, you'll need an Azure user account with:
- Owner permissions on the Azure subscription
- Permissions to register Azure Active Directory apps

If you just created a free Azure account, you're the owner of your subscription. If you're not the subscription owner, work with the owner to assign the permissions as follows:

1. In the Azure portal, search for "subscriptions", and under **Services**, select **Subscriptions**.

    ![Search box to search for the Azure subscription.](https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/migrate/media/tutorial-discover-vmware/search-subscription.png)

2. In the **Subscriptions** page, select the subscription in which you want to create an Azure Migrate project.
3. In the subscription, select **Access control (IAM)** > **Check access**.
4. In **Check access**, search for the relevant user account.
5. In **Add a role assignment**, click **Add**.

    ![Search for a user account to check access and assign a role.](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/migrate/media/tutorial-discover-vmware/azure-account-access.png?raw=true)

6. In **Add role assignment**, select the Owner role, and select the account (azmigrateuser in our example). Then click **Save**.

    ![Opens the Add Role assignment page to assign a role to the account.](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/migrate/media/tutorial-discover-vmware/assign-role.png?raw=true)

7. Your Azure account also needs **permissions to register Azure Active Directory apps.**
8. In Azure portal, navigate to **Azure Active Directory** > **Users** > **User Settings**.
9. In **User settings**, verify that Azure AD users can register applications (set to **Yes** by default).

      ![Verify in User Settings that users can register Active Directory apps.](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/migrate/media/tutorial-discover-vmware/register-apps.png?raw=true)

10. In case the 'App registrations' settings is set to 'No', request the tenant/global admin to assign the required permission. Alternately, the tenant/global admin can assign the **Application Developer** role to an account to allow the registration of Azure Active Directory App. [Learn more](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/active-directory/fundamentals/active-directory-users-assign-role-azure-portal.md).