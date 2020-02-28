select reports_reporttemplate.*, rtype.name as report_type_name, customer.customername as customer_name 
	from reports_reporttemplate
	inner join reports_reporttype as rtype on report_type_id = rtype.id
	inner join customer on owner_customer_id = customer.customerid
	where rtype.slug in ('portfolio_impact', 'vulnerability_trends', 'infection_trends')
		and settings like '%"filters":{"%'
		and customer.is_real = 1;