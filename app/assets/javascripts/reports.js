function rep_det_sum(){
    if ($(post_person_id).val() == "")
        $('div#sum_det').show();
    else
        $('div#sum_det').hide();
}