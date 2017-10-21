import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

if (Meteor.isClient) {

	Template.myTemplate.events({
		'submit form': function(event){
			event.preventDefault();
			var template = Template.instance();
			var textValue = event.target.myForm.value;
			var ethBalance;

			web3.eth.getBalance(textValue,
				function (err,res){
					ethBalance = web3.fromWei(res, "ether");
					TemplateVar.set(template, "counter",ethBalance);
					TemplateVar.set(template, "accnumber",textValue);
				})
			event.target.myForm.value = "";
		}

	})
}