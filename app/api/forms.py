from django import forms
from .models import Api # Model name should match your actual model

class PostForm(forms.ModelForm):
    title = forms.CharField(required=True, widget=forms.TextInput(attrs={'class': 'form-control'}))
    contents = forms.CharField(required=True, widget=forms.Textarea(attrs={'Placeholder': 'Your contents', 'class': 'form-control'}))
    email = forms.EmailField()
    author = forms.CharField(required=True, label='Author *', widget=forms.TextInput(attrs={'class': 'form-control'}))
    description = forms.CharField(required=False, widget=forms.TextInput(attrs={'class': 'form-control'}))
    class Meta:
        model = Api
        fields = ['title', 'contents','author', 'description']


    # Field validation
    def clean_title(self):
        title = self.cleaned_data.get('title')
        if 'admin' in title:
            raise forms.ValidationError("This is not valid title")
        else:
           return title

    # Field validation
    #def clean_email(self):
    #    email = self.cleaned_data.get('email')
    #    if not '@' in email:
    #        raise forms.ValidationError("This is not valid email")
    #    else:
    #       return email

class RawForm(forms.Form):
    title = forms.CharField(required=True, label="Title")
    contents = forms.CharField(required=True, label="Contents")
    author = forms.CharField(required=True, label="Author")
    description = forms.CharField(required=False)

