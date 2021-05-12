# ASP.NET App Containerization Exercise 

In this exercise, you'll learn how to:

> * Set up an Azure account.
> * Install the Azure Migrate: App Containerization tool.
> * Deploy a sample ASP.NET application on the server.
> * Perform application discovery on the server
> * Build the container image.
> * Deploy the containerized application on AKS.

A collection of helper utilities, classes and controls to augment UWP MVVM applications.   Built around the popular MVVMLight Framework, AMP was born from several past MTV projects and Alley demos.  It helps solve common problems like asynchronous view models, visual state management, and commanding with various controls.
Collected from various articles, projects, etc.

## NavAware ViewModels
You may need ViewModels to perform actions when users navigate to the viewmodels respective views.  The *NavAwarePage* and *NavAwareViewModel* can be used to accomplish this.

The *NavAwarePage* base class should be used in place of all XAML *Page* base classes.  The *NavAwarePage* will call the *Activate* method on a *NavAwareViewModel* when navigating to a page, and will call the  *Decactivate* method when navigating away from a *NavAwarePage*.

**To use:**
Implement your own ViewModel inheriting from the NavAwareViewModel base class:
```csharp
public class MyViewModel : NavAwareViewModel
```
Override the *Activate* and/or *Deactivate* methods in  your new class:
```csharp
public override void Activate(object parameter)
{ \\ Do work here}

public override void Deactivate(object parameter)
{ \\ Do work here}
```

The passed in *parameter* value will be the same as whatever state object passed in the Page navigation.

Replace your View's *Page* base class with the *NavAwarePage* class. Your *NavAwareViewModel* must be the *NavAwarePage*'s DataContext in order for the *Activate/Deactive* methods to be called correctly.

## Asychronous ViewModels
Often times, you need to perform actions asynchronously when your viewmodels are loaded.The *AsyncViewModel* is a specific implementation of a *NavAwareViewModel* that allows async operations to be peformed when the ViewModel is initially loaded.  