var data={
    groups:[
    {
        id:1,
        lang:"en",
        url:"/groups/oakland",
        name:"East Bay Rising",
        description: "Taking action to defund communities in the east bay ",
        status:'live',
        city:"Oakland",
        region:"CA",
        zip:"94602",
        country:"US",
        latitude:"37.8044",
        longitude:"-122.2708",
        truf_range:"10",
        turf_shape:[
            "37.96260604160774, -122.42752075195312",
            "37.90411590881245, -122.39593505859375",
            "37.826056694926535, -122.34100341796875",
            "37.74357118744906, -122.28469848632812",
            "37.689254214025276, -122.22015380859375",
            "37.73053874574077, -122.09518432617188",
            "37.83148014503287, -122.08419799804688",
            "37.95286091815649, -122.23251342773438"
        ],
        contact_name:"Jane Doe",
        contact_phone:"555-555-5555",
        contact_email:"name@gmail.com",
        facebook_page_url:"http://facebook.com/STOPtrump",
        website_url:"https://bayresistance.org",
        twitter:"STOPtrump",
        notes:[
            {
                note:"This is a great group",
                date_created: "2017-01-10",
                admin_user:"David"
            },
            {
                note:"They turned out 20 people to the march",
                date_created: "2017-01-17",
                admin_user:"Annie"
            },
        ],
        stats:{
            member_count:10,
            recent_count:3,
            universe_count:5234            
        },
        leaders:[
            {
                user_id:"",
                name:"Jane Doe",
                facebook_id:"61731840657"
            },
            {
                user_id:"",
                name:"Bob Activist",
                facebook_id:"124955570892789"
            }            
        ],
        updates:{
            sticky:[
                {
                    group_update_id:2343,
                    title:"Welcome to Our Group Page",
                    content:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc imperdiet sodales mauris ut venenatis. Sed condimentum id nulla vel hendrerit. Vivamus eget egestas metus. Sed in ante vel ligula lobortis tristique vitae vitae nunc. Quisque sodales nec lorem at vehicula. Maecenas convallis eleifend sem et vulputate. Aliquam id risus massa. Quisque mollis dolor magna, ut finibus purus ornare ac.",
                    date:"",
                    sticky:"",  
                    user_id:"",              
                    published:true
                }
            ],
            regular:[
                {
                    group_update_id:2343,
                    title:"This is an important update",
                    content:"fLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc imperdiet sodales mauris ut venenatis. Sed condimentum id nulla vel hendrerit. Vivamus eget egestas metus. Sed in ante vel ligula lobortis tristique vitae vitae nunc. Quisque sodales nec lorem at vehicula. Maecenas convallis eleifend sem et vulputate. Aliquam id risus massa. Quisque mollis dolor magna, ut finibus purus ornare ac.",
                    date:"2017-01-01",
                    sticky:"",  
                    user_id:"",              
                    published:true
                }
            ]
        },
        
        members:[
            {
                user_id:12345,
                avatar:"",
                first_name:"Jane",
                last_name:"Doe",
                phone:"555-555-5555",
                email:"name@gmail.com",
                facebook_user_id:61731840657,
                twitter_name:"dDoe",
                activist_score:"4",
                date_created:"2017-01-08",
                date_updated:"2017-01-08",
                group_admin:false,

                tags:[
                    {
                        tag_id:"23",
                        tag:"Puppy Lover"
                    }  ,              
                    {
                        tag_id:"43",
                        tag:"Phone Bank"
                    }  
                ],
                stats:{
                    activity_count:0,
                    event_count:1,
                    date_last_active:"2016-12-23"
                },
                notes:[
                    {
                        id:"23434",
                        note:"Is a lawyer and can help with legal observing",
                        date:"2017-01-02",
                        logged_by_user:{
                            id:1,
                            name:'Davey T'   
                        }      
                    }
                ],              
                events:[
                    {
                        id:122,
                        name:"Weekly Meeting",
                        date:"2017-01-02",
                        status:"rsvp"
                    }
                ],
                activities:[
                    {
                        id:"",
                        activity:"",
                        date:"",
                        logged_by_user:{
                            id:1,
                            name:'Davey T'   
                        }
                    }
                ]
            },
            {
                user_id:12345344,
                avatar:"",
                first_name:"Edward",
                last_name:"Activst",
                phone:"555-555-5555",
                email:"email@gmail.com",
                facebook_user_id:124955570892789,
                twitter_name:"",
                activist_score:"2",
                date_created:"2017-01-08",
                date_updated:"2017-01-08",
                group_admin:false,

                tags:[
                    {
                        tag_id:"18",
                        tag:"Facilitator"
                    }  ,              
                    {
                        tag_id:"78",
                        tag:"NVDA Trainer"
                    }  
                ],
                stats:{
                    activity_count:0,
                    event_count:1,
                    date_last_active:"2016-12-23"
                },
                notes:[
                    {
                        id:"23434",
                        note:"Very reliable but needs notice to take on tasks",
                        date:"2017-01-02",
                        logged_by_user:{
                            id:1,
                            name:'Davey T'   
                        }      
                    }
                ],              
                events:[
                    {
                        id:122,
                        name:"Weekly Meeting",
                        date:"2017-01-02",
                        status:"rsvp"
                    }
                ],
                activities:[
                    {
                        id:"",
                        activity:"",
                        date:"",
                        logged_by_user:{
                            id:1,
                            name:'Davey T'   
                        }
                    }
                ]
            }
        ],
        nearby_groups:[
            {
                name:"San Francisco Actions",
                group_id:"12",
                url:"groups/san_francsico",
                city:"San Francisco",
                distance:"14"
            },
            {
                name:"San Jose Action Group",
                group_id:"12",
                city:"San Jose",
                url:"groups/san_jose",
                distance:"37"
            }
        ],
        events:[
            {
                id:1234,
                date:"2017-02-01",
                start_time:"19:30",
                name:"Local Organzing Meeting",
                description:"This is a great meeting you should come to",
                location:{
                    address:"1234 Main St",
                    city:"Oakland",
                    state:"CA",
                    postal_code:"94610",
                    country:"US",
                    latitude:37.8044,
                    longitude:-122.2708,
                    venue:"Meeting Room B, Union Hall",
                    directions:"Buzz Union Local 12344 at the front door to be let in"
                },
                status:"public",
                stats:{
                    invited_count:12,
                    rsvp_count:3,
                    interested_count:2,
                    declined_count:6,
                    attended_count:9,
                    not_attended_count:12
                },
                users:
                    {
                        invited: [
                            {
                                id:1233,
                                first_name:"Bob",
                                last_name:"Fishhead",
                                facebook_user_id:"61731840657",
                                phone:"333-333-3333",
                                date:"2017-01-01"
                            } ,
                            {
                                id:123433,
                                first_name:"Sam",
                                last_name:"Goatface",
                                facebook_user_id:"61731840657",
                                phone:"333-333-3333",
                                date:"2017-01-01"
                            } 
    
                        ],
                        rsvp:[
                            {
                                id:1233,
                                first_name:"Jane",
                                last_name:"Doe",
                                facebook_user_id:"",
                                phone:"555-555-5555",
                                date:"2017-01-01"
                            },
                            {
                                id:1233,
                                first_name:"Edward",
                                last_name:"Activst",
                                facebook_user_id:"",
                                phone:"111-111-1111",
                                date:"2017-01-01"
                            }
                        ]
                    }

                

            }
        ]
    },
    {
        id:2,
        lang:"en",
        url:"/groups/sf",
        name:"SF Action",
        description: "We are a super awesome group that is doing an lot of important organizing in our region",
        status:'pending',
        city:"San Francisco",
        region:"CA",
        zip:"94110",
        country:"US",
        contact_name:"Jose Doe",
        contact_phone:"555-555-5555",
        contact_email:"otheranme@gmail.com",
        facebook_page_url:"http://facebook.com/STOPtrump",
        twitter:"STOPtrump",
        notes:[
            {
                note:"This is a also a great group",
                date_created: "2017-01-10",
                admin_user:"David"
            }

        ],
        stats:{
            member_count:1234,
            recent_count:3,
            universe_count:5234            
        },

        leaders:[
            {
                user_id:"1323",
                name:"Jose Doe",
                facebook_id:"61731840657"
            },
            {
                user_id:"233",
                name:"Sally Person",
                facebook_id:"124955570892789"
            }            
        ]
     
    }
    
    ],
    tags:[
        {
            id:1,
            name:"Volunteer"
        },
        {
            id:2,
            name:"Kitten Lover"
        },
        {
            id:3,
            name:"Trainer"
        },
        {
            id:4,
            name:"Nerd"
        },
        {
            id:5,
            name:"Phone Bank"
        }
    ],
    admin_user:{
        user_id:"",
        name:"Jane Doe",
        facebook_id:"61731840657"        
    }
}